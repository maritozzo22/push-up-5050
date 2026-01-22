# Flutter Planner Agent

**An intelligent, adaptive planning agent that guides you through complete Flutter app planning—from idea to detailed specifications.**

## Overview

Flutter Planner is not just a questionnaire—it's a **design partner** that:
- ✅ Educates about design concepts with examples
- ✅ Shows visual previews (ASCII art, references)
- ✅ Asks adaptive questions based on your answers
- ✅ Gets feedback after EACH screen (not just at end)
- ✅ Analyzes reference images you provide
- ✅ Creates beautiful, cohesive design systems
- ✅ Generates PRD, UI mockups, and implementation plan

## When to Use

Use Flutter Planner when:
- ✅ You have an app idea and want to plan it completely
- ✅ You're not a designer/programmer and need guidance
- ✅ You want your app to look beautiful, not just functional
- ✅ You want to avoid design inconsistencies
- ✅ You want to understand the WHY behind design choices

**Don't use when**:
- ❌ You already have PRD and just need mockups (use ui-mockup-generator)
- ❌ You already have mockups and just need implementation (use flutter-creator)
- ❌ You want to iterate on existing documents (use individual skills)

## How It Works

### Complete Planning Workflow

```
User: "Plan my [app description] completely"

↓

Phase 1: Understanding (5-10 min)
├─ Open questions about your vision
├─ Adaptive questions based on app type
└─ Identify unique features and audience

↓

Phase 2: Design System (10-15 min) ⭐ MOST IMPORTANT
├─ Visual style discovery (with examples)
├─ Color scheme selection (with ASCII previews)
├─ Typography and spacing (visual comparisons)
├─ Component design (buttons, cards, inputs)
└─ UX patterns (gestures, animations, navigation)

↓

Phase 3: Generate PRD
├─ Calls prd-generator skill
├─ Creates PRD.md (requirements)
└─ Creates PIP.md (implementation plan)

↓

Phase 4: Generate UI Mockups (20-30 min)
├─ For EACH screen:
│  ├─ Generate ASCII mockup
│  ├─ Show to user with explanation
│  ├─ Get feedback (AskUserQuestion)
│  ├─ Iterate if needed
│  └─ Approve → next screen
└─ Creates MOCKUP.md

↓

Phase 5: Update PIP
└─ Updates PIP.md with mockup details

↓

Phase 6: Final Report
└─ Shows design summary + next steps

Output: 3 Coherent Documents
├─ PRD.md (what to build)
├─ MOCKUP.md (how it looks)
└─ PIP.md (how to build + test)
```

### Key Features

#### 1. Adaptive Questioning
Questions change based on your answers:
- Game app → Ask about scoring, levels, fun factor
- Productivity app → Ask about workflows, efficiency
- Social app → Ask about engagement, sharing

#### 2. Visual Education
Every design concept explained with:
- Text descriptions
- ASCII art examples
- Reference app comparisons
- Links to external resources (Dribbble, Material Design)

#### 3. Reference Image Analysis
If you provide screenshots:
```
User: "I like the look of these apps" + [screenshots]

Agent: [Analyzes with MCP tool]
       "Based on your screenshots, I notice:
       - Color scheme: Purple gradient (#9C27B0 → #7B1FA2)
       - Layout: Card-based with rounded corners
       - Typography: Modern sans-serif, bold headings
       Should we use this style?"
```

#### 4. Feedback Per Screen
Not generic approval—specific feedback after each screen:
```
Agent: "Here's your HomeScreen mockup:
       [Shows ASCII art]

       What do you think?
       A) Perfect, proceed!
       B) Change [specific element]
       C) Show me alternative layout
       D) Explain [X] in more detail"
```

#### 5. Beauty Focus
Design is prioritized, not an afterthought:
- 10-15 minutes on design system (colors, typography, spacing)
- Explanation of color theory, what makes apps "feel premium"
- Multiple options with visual examples
- Encouragement when you make good choices

## Example Session

See `examples/session-transcript.md` for complete example conversation.

## Time Estimates

| Phase | Time | What Happens |
|-------|------|--------------|
| Understanding | 5-10 min | Questions about your vision |
| Design System | 10-15 min | Colors, typography, spacing, UX |
| PRD Generation | 5 min | Requirements document |
| UI Mockups | 20-30 min | Screen-by-screen design with feedback |
| PIP Update | 2-3 min | Implementation plan |
| **Total** | **45-70 min** | Complete app planning |

*Compare to: 2-4 hours without AI assistance*

## Output Files

After planning, you get:

### 1. PRD.md (Product Requirements Document)
- App overview and purpose
- Features (must-have, nice-to-have)
- User journey and flows
- Screens list
- Edge cases and error handling

### 2. MOCKUP.md (UI Specifications)
- Design system (colors HEX, typography, spacing)
- Component library (Button, Card, Input, etc.)
- Navigation flow (user flows, route map)
- Screen mockups:
  - ASCII layout (mobile)
  - Element hierarchy
  - 5 state variations (normal, loading, error, empty, success)
  - Responsive rules (desktop/tablet)

### 3. PIP.md (Project Implementation Plan)
- Development phases
- Feature breakdown with TDD workflow
- Testing strategy (unit, widget, integration, golden)
- Implementation details from mockups

## How to Use

### Basic Usage

```
You: "Plan my task manager app completely"

Agent: [Starts adaptive questioning]
      → Asks about your vision
      → Shows design options with examples
      → Gets your preferences
      → Generates PRD
      → Creates mockups one-by-one with feedback
      → Updates PIP
      → Final report

✅ Result: 3 coherent documents ready for implementation
```

### With Reference Images

```
You: "Plan my fitness app. Here are apps I like:"
     [Provides 2-3 screenshots]

Agent: [Analyzes screenshots with MCP]
      "I see you prefer:
       - Vibrant green colors (#4CAF50)
       - Dark background for charts
       - Circular progress indicators
       Should we use this style?"

You: "Yes, but with blue instead of green"

Agent: [Adapts design system]
      "Perfect! Blue (#2196F3) on dark background.
       Let me show you how it will look..."
      [Shows ASCII mockup]
```

### Iterative Design

```
Agent: "Here's your HomeScreen mockup:
       [Shows ASCII]

You: "I don't like the FAB position"

Agent: "No problem! Let me show alternatives:
       Option A: FAB top-right (standard)
       Option B: FAB center-bottom (thumb-friendly)
       Option C: No FAB, use button in top bar

       [Shows ASCII for each option]"

You: "Option B looks better"

Agent: "Great choice! Center-bottom is easiest to reach.
       Updating mockup..."
      [Shows updated mockup]
      "What do you think?"

You: "Perfect!"
```

## Agent vs Individual Skills

| Feature | Flutter Planner Agent | Individual Skills |
|---------|----------------------|-------------------|
| Time to plan | 45-70 min (one session) | 60-90 min (multiple sessions) |
| Questions asked | Once (adaptive) | Repeated in each skill |
| Design coherence | Perfect (single vision) | Good (if manual coordination) |
| Learning about design | High (educational) | Medium (less explanation) |
| Visual feedback | Per screen | Per document |
| Best for | New apps from scratch | Iterations on existing docs |
| User expertise needed | None (educates) | Some (assumes basics) |

## What Makes This Agent Different

### 1. Design-Led, Not Feature-Led
Most planners start with "What features?"
Flutter Planner starts with "How should it FEEL?"

Design system phase (10-15 min) ensures:
- Beautiful color combinations
- Typography that's readable and stylish
- Proper spacing (whitespace = premium feel)
- Cohesive component design

### 2. Educational, Not Interrogative
Doesn't just ask questions—teaches design:

```
❌ Bad: "What spacing system?"
✅ Good: "How much breathing room?

    Option A: Tight (4-8px gaps)
    [Shows ASCII: tight layout]
    Use: Data-heavy apps

    Option B: Standard (16px gaps)
    [Shows ASCII: balanced layout]
    Use: Most apps (recommended)

    Option C: Spacious (24-32px gaps)
    [Shows ASCII: premium feel]
    Use: Luxury brands"
```

### 3. Visual, Not Textual
Every design decision shown visually:
- ASCII art for layouts
- Color swatches with HEX codes
- Before/after comparisons
- Reference app examples

### 4. Adaptive, Not Static
Questions change based on your answers:
- You say "game" → Asks about scoring, levels
- You say "productivity" → Asks about workflows
- You say "confused" → Simplifies, provides more examples

### 5. Feedback Per Screen, Not Per Document
Doesn't generate 10 screens then ask "Is this ok?"
Generates 1 screen → asks "What do you think?" → iterates → next screen

## Design Expertise Level

The agent assumes **intermediate knowledge**:
- You know what a "button" is
- You don't know what "elevation" means → explains as "shadow effect"
- You don't know what "responsive" means → explains as "adapts to screen size"

If you're more expert → dives deeper into technical details
If you're less expert → simplifies everything

## Technical Details

### Tools Used
- **AskUserQuestion**: For structured choices
- **mcp__4_5v_mcp__analyze_image**: For reference image analysis
- **prd-generator skill**: For requirements document
- **ui-mockup-generator skill**: For visual specifications

### File Structure
```
.claude/agents/flutter-planner/
├── AGENT.md                   ← Main agent logic
├── README.md                  ← This file
└── examples/
    ├── session-transcript.md  ← Example complete session
    └── before-after/          ← Design transformations
```

### Generated Files
- `PRD.md` (by prd-generator)
- `MOCKUP.md` (by ui-mockup-generator)
- `PIP.md` (by prd-generator, updated by agent)

## Next Steps After Planning

Once Flutter Planner completes:

```
1. Review generated documents
   - PRD.md (requirements)
   - MOCKUP.md (visual design)
   - PIP.md (implementation plan)

2. Say: "Implement my app"
   → flutter-creator reads all 3 documents
   → Generates Flutter code

3. Say: "Generate tests"
   → flutter-testing reads PIP.md
   → Creates comprehensive tests
```

## Comparison: Agent vs Manual

| Aspect | With Agent | Without Agent |
|--------|-----------|---------------|
| Planning time | 45-70 min | 2-4 hours |
| Design knowledge | Learn during session | Need to research |
| Visual coherence | Perfect (single vision) | Inconsistent (trial & error) |
| Rework during implementation | Minimal | High (design gaps) |
| Learning | High (guided) | Low (figuring out alone) |
| Fun factor | High (creative session) | Low (frustrating) |

## Troubleshooting

**Q: The agent is asking too many questions!**
- A: This ensures perfect design. If impatient, say "Let's use standard defaults" to speed up.

**Q: I don't know design terminology.**
- A: Perfect! The agent explains everything. No prior knowledge needed.

**Q: Can I provide my own designs?**
- A: Yes! Share screenshots or describe in detail. Agent will adapt.

**Q: Can I stop and continue later?**
- A: Yes! Say "Save progress". Documents generated so far are saved.

**Q: What if I don't like the mockup?**
- A: That's why agent asks for feedback EACH screen. Just say what to change.

## Tips for Best Results

1. **Take time on design phase** (10-15 min)
   - This is where apps succeed or fail
   - Better to spend 15 min here than 2 hours revising code

2. **Provide reference images**
   - Screenshots of apps you like
   - Dribbble shots
   - Even rough sketches

3. **Be honest about confusion**
   - Don't understand "elevation"? Say so
   - Agent will explain with examples

4. **Ask for alternatives**
   - Don't like option A? Ask for B and C
   - Agent generates variations

5. **Give specific feedback**
   - "Move button to left" not "I don't like it"
   - More specific = better result

## Success Stories

### Example 1: Non-Technical User
```
User: "I want a habit tracker but I'm not a designer"

Agent: [Guides through design choices]
      "Let's pick a style that makes habits fun to track..."

Result: Beautiful playful app with bouncy animations,
        user said "It's even better than I imagined!"
```

### Example 2: Design-Savvy User
```
User: "I want a minimalist finance app. Here are my references:" + [screenshots]

Agent: [Analyzes screenshots]
      "I see you prefer: Clean lines, muted blues, lots of whitespace.
       Let's refine this for your app..."

Result: Cohesive design system, user said "Exactly what I wanted!"
```

### Example 3: Game App
```
User: "I want a quiz game that feels exciting"

Agent: [Adapts to game context]
      "For games, let's use vibrant colors and bouncy animations.
       Here's how it will feel..."

Result: Colorful, fun app with rich animations,
        perfect for game engagement
```

## License

Part of BuilderPack collection. See main repository for license information.

## Related Tools

- **prd-generator**: Creates requirements documents
- **ui-mockup-generator**: Creates UI specifications
- **flutter-creator**: Implements Flutter code
- **flutter-testing**: Creates tests
- **skill-creator-plus**: Framework for creating skills/agents

---

**Ready to plan your beautiful app? Just say:**

```
"Plan my [app description] completely"
```

**And let's create something amazing together!** 🎨✨
