# UI Mockup Generator Skill

Generate detailed, implementation-ready UI mockups for Flutter apps with ASCII art, CSS specifications, and complete state coverage.

## Overview

This skill bridges the gap between PRD (what to build) and code (how to build) by creating detailed visual specifications that ensure implementation matches design vision.

## When to Use

Use this skill **after** completing PRD and **before** starting implementation:

1. ✅ PRD is complete (use `prd-generator` skill first)
2. ✅ You know what screens you need
3. ✅ You're ready to think about visual design
4. ❌ Don't use before PRD (requirements unclear)
5. ❌ Don't use during implementation (too late)

## How to Use

### Basic Usage

```
User: Generate UI mockups for my task manager app

Claude: [Uses ui-mockup-generator skill]
       1. Reads PRD.md if it exists
       2. Asks design system questions (colors, typography, spacing)
       3. For each screen:
          - Asks screen-specific questions
          - Generates ASCII layout
          - Lists all elements
          - Creates all state variations
          - Adds responsive rules
       4. Creates MOCKUP.md with complete specifications
```

### Triggering the Skill

The skill automatically triggers when you say:
- "create mockup"
- "generate ui mockup"
- "design screens"
- "ui layout"
- "visual spec"
- "mockup from prd"
- "screen design"
- "interface mockup"

### Integration with Other Skills

**Complete Flutter Development Workflow**:

```
1. prd-generator
   ↓ Output: PRD.md + PIP.md
   ↓
2. ui-mockup-generator (this skill)
   ↓ Output: MOCKUP.md
   ↓
3. flutter-creator
   ↓ Reads: MOCKUP.md
   ↓ Output: Flutter code
   ↓
4. flutter-testing
   ↓ Reads: PIP.md + Flutter code
   ↓ Output: Tests
```

## What This Skill Generates

### Single Output File: `MOCKUP.md`

Contains:
- **Design System**: Colors (HEX), typography, spacing
- **Component Library**: Reusable widgets (Button, Card, Input, etc.)
- **Navigation Flow**: User flows, route map, interaction types
- **Screen Mockups**: ASCII layout + element hierarchy + states + responsive rules

### For Each Screen

1. **ASCII Layout** (mobile visualization)
2. **Element Hierarchy**: All UI elements with positions
3. **5 State Variations**:
   - Normal state
   - Loading state
   - Error state
   - Empty state
   - Success state
4. **Responsive Rules**: How layout adapts to desktop/tablet
5. **Flutter Implementation Hints**: Widget suggestions
6. **Navigation**: From/to screens, interaction types

## Key Features

### ✅ Complete State Coverage
Every screen includes all 5 states (not just happy path)

### ✅ Responsive by Design
Mobile ASCII mockup + responsive rules for larger screens

### ✅ Precise Specifications
- HEX colors only (no RGB, no named colors)
- Pixel dimensions + Flutter widget hints
- Exact positioning (not "somewhere on screen")

### ✅ Component Library
Reusable components defined once, referenced everywhere

### ✅ Navigation Explicit
User flows + route map + interaction types (push, pop, switch)

### ✅ Interactive Workflow
Asks questions before generating to understand your vision

### ✅ Reference Image Analysis (Optional)
If you provide screenshots, analyzes them for layout/color/style patterns

## Output Quality

This skill generates production-ready mockups that:

- ✅ Need no guessing during implementation
- ✅ Prevent visual inconsistencies
- ✅ Ensure all edge cases are handled
- ✅ Make responsive design explicit
- ✅ Serve as single source of truth for UI

## Philosophy

**Visual Clarity Prevents Rework**

Vague specifications lead to wrong implementations. Detailed mockups ensure what gets built matches what was imagined.

See SKILL.md for complete philosophy and guidelines.

## Examples

See `examples/example-output.md` for complete mockup of a task manager app.

## Skill Quality Score

**96/100** (analyzed with skill-creator-plus)

- Philosophy Foundation: 38/40
- Anti-Pattern Prevention: 25/25
- Variation Encouragement: 18/20
- Organization: 10/10
- Empowerment vs Constraint: 5/5

## Requirements

- **Prerequisite**: PRD.md should exist (use `prd-generator` first)
- **Time**: 10-30 minutes depending on app complexity
- **User Input**: Design preferences (colors, typography, layout preferences)

## Tips for Best Results

1. **Have PRD ready**: Know what screens you need before starting
2. **Know your preferences**: Have color scheme, typography style in mind
3. **Be specific**: The more specific your answers, the better the mockup
4. **Provide references**: If you have screenshot inspirations, share them
5. **Think responsive**: Consider how layout should adapt to desktop/tablet

## Anti-Patterns to Avoid

❌ **Don't skip questions**: Answer all questions for best results
❌ **Don't rush**: Take time to think about visual design
❌ **Don't ignore states**: Ensure all 5 states make sense for your app
❌ **Don't forget responsive**: Consider desktop/tablet layouts
❌ **Don't use too early**: Wait until PRD is complete

## Troubleshooting

**Q: Skill asks too many questions!**
A: This ensures mockup matches your vision. Be patient—it prevents rework later.

**Q: Can I generate mockup without PRD?**
A: Yes, but having PRD.md is recommended for complete screen list and context.

**Q: How do I update mockup after changes?**
A: Re-run skill with "Update mockup for [screen name] to reflect changes: ..."

**Q: Can I generate only specific screens?**
A: Yes, say "Generate mockup for [screen name] only"

**Q: What if I don't know color values?**
A: Skill provides default color schemes to choose from, or you can pick later.

## License

Part of BuilderPack collection. See main repository for license information.

## Related Skills

- **prd-generator**: Create PRD/PIP before using this skill
- **flutter-creator**: Implement mockups after using this skill
- **flutter-testing**: Test implemented features
- **skill-creator-plus**: Philosophy-first skill creation framework
