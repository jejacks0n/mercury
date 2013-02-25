/**
 * Highlighter module for Rangy, a cross-browser JavaScript range and selection library
 * http://code.google.com/p/rangy/
 *
 * Depends on Rangy core, TextRange and CssClassApplier modules.
 *
 * Copyright 2013, Tim Down
 * Licensed under the MIT license.
 * Version: 1.3alpha.755
 * Build date: 29 January 2013
 */
rangy.createModule("Highlighter", function(api, module) {
    api.requireModules( ["CssClassApplier"] );

    var dom = api.dom;
    var contains = dom.arrayContains;

    // Puts highlights in order, last in document first.
    function compareHighlights(h1, h2) {
        return h1.characterRange.start - h2.characterRange.start;
    }

    var forEach = [].forEach ?
        function(arr, func) {
            arr.forEach(func);
        } :
        function(arr, func) {
            for (var i = 0, len = arr.length; i < len; ++i) {
                func( arr[i] );
            }
        };

    var nextHighlightId = 1;

    /*----------------------------------------------------------------------------------------------------------------*/

    var highlighterTypes = {};

    function HighlighterType(type, converterCreator) {
        this.type = type;
        this.converterCreator = converterCreator
    }

    HighlighterType.prototype.create = function() {
        var converter = this.converterCreator();
        converter.type = this.type;
        return converter;
    };

    function registerHighlighterType(type, converterCreator) {
        highlighterTypes[type] = new HighlighterType(type, converterCreator);
    }

    function getConverter(type) {
        var highlighterType = highlighterTypes[type];
        if (highlighterType instanceof HighlighterType) {
            return highlighterType.create();
        } else {
            throw new Error("Highlighter type '" + type + "' is not valid")
        }
    }

    api.registerHighlighterType = registerHighlighterType;

    /*----------------------------------------------------------------------------------------------------------------*/

    function CharacterRange(start, end) {
        this.start = start;
        this.end = end;
    }

    CharacterRange.prototype = {
        intersects: function(charRange) {
            return this.start < charRange.end && this.end > charRange.start;
        },

        union: function(charRange) {
            return new CharacterRange(Math.min(this.start, charRange.start), Math.max(this.end, charRange.end));
        },

        toString: function() {
            return "[CharacterRange(" + this.start + ", " + this.end + ")]";
        }
    };

    CharacterRange.fromCharacterRange = function(charRange) {
        return new CharacterRange(charRange.start, charRange.end);
    };

    /*----------------------------------------------------------------------------------------------------------------*/

    var textContentConverter = {
        rangeToCharacterRange: function(range) {
            var preSelectionRange = range.cloneRange();
            preSelectionRange.selectNodeContents( range.getDocument().body );
            preSelectionRange.setEnd(range.startContainer, range.startOffset);
            var start = preSelectionRange.toString().length;
            
            return new CharacterRange(start, start + range.toString().length);
        },

        characterRangeToRange: function(doc, characterRange) {
            var charIndex = 0, range = api.createRange(doc);
            var body = doc.body;
            range.setStart(body, 0);
            range.collapse(true);
            var nodeStack = [body], node, foundStart = false, stop = false;

            while (!stop && (node = nodeStack.pop())) {
                if (node.nodeType == 3) {
                    var nextCharIndex = charIndex + node.length;
                    if (!foundStart && characterRange.start >= charIndex && characterRange.start <= nextCharIndex) {
                        range.setStart(node, characterRange.start - charIndex);
                        foundStart = true;
                    }
                    if (foundStart && characterRange.end >= charIndex && characterRange.end <= nextCharIndex) {
                        range.setEnd(node, characterRange.end - charIndex);
                        stop = true;
                    }
                    charIndex = nextCharIndex;
                } else {
                    var i = node.childNodes.length;
                    while (i--) {
                        nodeStack.push(node.childNodes[i]);
                    }
                }
            }

            return range;
        },

        serializeSelection: function(selection) {
            var ranges = selection.getAllRanges(), rangeCount = ranges.length;
            var rangeInfos = [];

            var backward = rangeCount == 1 && selection.isBackward();

            for (var i = 0, len = ranges.length; i < len; ++i) {
                rangeInfos[i] = {
                    characterRange: this.rangeToCharacterRange(ranges[i]),
                    backward: backward
                };
            }

            return rangeInfos;
        },

        restoreSelection: function(selection, savedSelection) {
            selection.removeAllRanges();
            var doc = selection.win.document;
            for (var i = 0, len = savedSelection.length, range, rangeInfo, characterRange; i < len; ++i) {
                rangeInfo = savedSelection[i];
                characterRange = rangeInfo.characterRange;
                range = this.characterRangeToRange(doc, rangeInfo.characterRange);
                selection.addRange(range, rangeInfo.backward);
            }
        }
    };

    registerHighlighterType("textContent", function() {
        return textContentConverter;
    });

    /*----------------------------------------------------------------------------------------------------------------*/

    // Lazily load the TextRange-based converter so that the dependency is only checked when required.
    registerHighlighterType("TextRange", (function() {
        var converter;

        return function() {
            if (!converter) {
                // Test that textRangeModule exists and is supported
                var textRangeModule = api.modules.TextRange;
                if (!textRangeModule) {
                    throw new Error("TextRange module is missing.");
                } else if (!textRangeModule.supported) {
                    throw new Error("TextRange module is present but not supported.");
                }

                converter = {
                    rangeToCharacterRange: function(range) {
                        return CharacterRange.fromCharacterRange( range.toCharacterRange() );
                    },

                    characterRangeToRange: function(doc, characterRange) {
                        var range = api.createRange(doc);
                        range.selectCharacters(doc.body, characterRange.start, characterRange.end);
                        return range;
                    },

                    serializeSelection: function(selection) {
                        return selection.saveCharacterRanges();
                    },

                    restoreSelection: function(selection, savedSelection) {
                        selection.restoreCharacterRanges(selection.win.document.body, savedSelection);
                    }
                }
            }

            return converter;
        }
    })());

    /*----------------------------------------------------------------------------------------------------------------*/

    function Highlight(doc, characterRange, classApplier, converter, id) {
        if (id) {
            this.id = id;
            nextHighlightId = Math.max(nextHighlightId, id + 1);
        } else {
            this.id = nextHighlightId++;
        }
        this.characterRange = characterRange;
        this.doc = doc;
        this.classApplier = classApplier;
        this.converter = converter;
        this.applied = false;
    }

    Highlight.prototype = {
        getRange: function() {
            return this.converter.characterRangeToRange(this.doc, this.characterRange);
        },

        fromRange: function(range) {
            this.characterRange = this.converter.rangeToCharacterRange(range);
        },

        containsElement: function(el) {
            return this.getRange().containsNodeContents(el.firstChild);
        },

        unapply: function() {
            this.classApplier.undoToRange(this.getRange());
            this.applied = false;
        },

        apply: function() {
            this.classApplier.applyToRange(this.getRange());
            this.applied = true;
        },

        toString: function() {
            return "[Highlight(ID: " + this.id + ", class: " + this.classApplier.cssClass + ", character range: " +
                this.characterRange.start + " - " + this.characterRange.end + ")]";
        }
    };

    /*----------------------------------------------------------------------------------------------------------------*/

    function Highlighter(doc, type) {
        type = type || "textContent";
        this.doc = doc || document;
        this.classAppliers = {};
        this.highlights = [];
        this.converter = getConverter(type);
    }

    Highlighter.prototype = {
        addClassApplier: function(classApplier) {
            this.classAppliers[classApplier.cssClass] = classApplier;
        },

        getHighlightForElement: function(el) {
            var highlights = this.highlights;
            for (var i = 0, len = highlights.length; i < len; ++i) {
                if (highlights[i].containsElement(el)) {
                    return highlights[i];
                }
            }
            return null;
        },

        removeHighlights: function(highlights) {
            for (var i = 0, len = this.highlights.length, highlight; i < len; ++i) {
                highlight = this.highlights[i];
                if (contains(highlights, highlight)) {
                    highlight.unapply();
                    this.highlights.splice(i--, 1);
                }
            }
        },

        getIntersectingHighlights: function(ranges) {
            // Test each range against each of the highlighted ranges to see whether they overlap
            var intersectingHighlights = [], highlights = this.highlights, converter = this.converter;
            api.noMutation(function() {
                forEach(ranges, function(range) {
                    var selCharRange = converter.rangeToCharacterRange(range);
                    forEach(highlights, function(highlight) {
                        if (selCharRange.intersects(highlight.characterRange) && !contains(intersectingHighlights, highlight)) {
                            intersectingHighlights.push(highlight);
                        }
                    });
                });
            });

            return intersectingHighlights;
        },

        highlightSelection: function(className, selection) {
            var i, j, len, converter = this.converter;
            selection = selection || api.getSelection();
            var classApplier = this.classAppliers[className];
            var highlights = this.highlights;
            var doc = this.doc, body = doc.body;

            if (!classApplier) {
                throw new Error("No class applier found for class '" + className + "'");
            }

            // Store the existing selection as character ranges
            var serializedSelection = converter.serializeSelection(selection);

            // Create an array of selected character ranges
            var selCharRanges = [];
            forEach(serializedSelection, function(rangeInfo) {
                selCharRanges.push( CharacterRange.fromCharacterRange(rangeInfo.characterRange) );
            });

            var highlightsToRemove = [];

            var selCharRange, highlightCharRange, merged;
            for (i = 0, len = selCharRanges.length; i < len; ++i) {
                selCharRange = selCharRanges[i];
                merged = false;

                // Check for intersection with existing highlights. For each intersection, create a new highlight
                // which is the union of the highlight range and the selected range
                for (j = 0; j < highlights.length; ++j) {
                    highlightCharRange = highlights[j].characterRange;

                    if (highlightCharRange.intersects(selCharRange)) {
                        // Replace the existing highlight in the list of current highlights and add it to the list for
                        // removal
                        highlightsToRemove.push(highlights[j]);
                        highlights[j] = new Highlight(doc, highlightCharRange.union(selCharRange), classApplier, converter);
                    }
                }

                if (!merged) {
                    highlights.push( new Highlight(doc, selCharRange, classApplier, converter) );
                }
            }

            // Remove the old highlights
            forEach(highlightsToRemove, function(highlightToRemove) {
                highlightToRemove.unapply();
            });

            // Apply new highlights
            forEach(highlights, function(highlight) {
                if (!highlight.applied) {
                    highlight.apply();
                }
            });

            // Restore selection
            converter.restoreSelection(selection, serializedSelection);

            return highlights;
        },

        unhighlightSelection: function(selection) {
            selection = selection || api.getSelection();
            var intersectingHighlights = this.getIntersectingHighlights( selection.getAllRanges() );
            this.removeHighlights(intersectingHighlights);
            selection.removeAllRanges();
        },

        selectionOverlapsHighlight: function(selection) {
            selection = selection || api.getSelection();
            return this.getIntersectingHighlights(selection.getAllRanges()).length > 0;
        },

        serialize: function() {
            var highlights = this.highlights;
            highlights.sort(compareHighlights);
            var serializedHighlights = ["type:" + this.converter.type];

            forEach(highlights, function(highlight) {
                var characterRange = highlight.characterRange;
                serializedHighlights.push( [
                    characterRange.start,
                    characterRange.end,
                    highlight.id,
                    highlight.classApplier.cssClass
                ].join("$") );
            });

            return serializedHighlights.join("|");
        },

        deserialize: function(serialized) {
            var serializedHighlights = serialized.split("|");
            var highlights = [];

            var firstHighlight = serializedHighlights[0];
            var regexResult;
            var serializationType, serializationConverter, convertType = false;
            if ( firstHighlight && (regexResult = /^type:(\w+)$/.exec(firstHighlight)) ) {
                serializationType = regexResult[1];
                if (serializationType != this.converter.type) {
                    serializationConverter = getConverter(serializationType);
                    convertType = true;
                }
                serializedHighlights.shift();
            } else {
                throw new Error("Serialized highlights are invalid.");
            }

            for (var i = serializedHighlights.length, parts, classApplier, highlight, characterRange; i-- > 0; ) {
                parts = serializedHighlights[i].split("$");
                characterRange = new CharacterRange(+parts[0], +parts[1]);

                // Convert to the current Highlighter's type, if different from the serialization type
                if (convertType) {
                    characterRange = this.converter.rangeToCharacterRange( serializationConverter.characterRangeToRange(this.doc, characterRange) );
                }

                classApplier = this.classAppliers[parts[3]];
                highlight = new Highlight(this.doc, characterRange, classApplier, this.converter, parts[2]);
                highlight.apply();
                highlights.push(highlight);
            }
            this.highlights = highlights;
        }
    };

    api.Highlighter = Highlighter;

    api.createHighlighter = function(doc, rangeCharacterOffsetConverterType) {
        return new Highlighter(doc, rangeCharacterOffsetConverterType);
    };
});
