# Flutter Planner Agent - Setup and Configuration

## Quick Start

Flutter Planner is ready to use! No installation required.

## Location

```
.claude/agents/flutter-planner/
├── AGENT.md                   ← Agent logic (read this first)
├── README.md                  ← User guide
├── SETUP.md                   ← This file
└── examples/
    └── session-transcript.md  ← Complete example session
```

## How to Invoke

### Method 1: Natural Language (Recommended)

Just say:
```
"Plan my [app description] completely"
```

Examples:
- "Plan my task manager app completely"
- "Plan my fitness tracker completely"
- "Plan my recipe sharing app completely"

### Method 2: Direct Reference

```
"Use flutter-planner agent to plan my [app]"
```

### Method 3: With Reference Images

```
"Plan my app using these designs as inspiration:" + [attach screenshots]
```

## What Happens When You Invoke

1. **Agent loads** from `.claude/agents/flutter-planner/AGENT.md`
2. **Phase 1**: Understanding (5-10 min)
   - Open questions about your vision
   - Adaptive questions based on app type
3. **Phase 2**: Design System (10-15 min) ⭐
   - Visual style with examples
   - Color selection with ASCII previews
   - Typography, spacing, components
   - UX patterns (animations, navigation)
4. **Phase 3**: PRD Generation (5 min)
   - Calls `prd-generator` skill
   - Creates PRD.md
5. **Phase 4**: UI Mockups (20-30 min)
   - Calls `ui-mockup-generator` skill
   - One screen at a time with feedback
   - Iterates until approved
   - Creates MOCKUP.md
6. **Phase 5**: PIP Update (2-3 min)
   - Updates implementation plan
7. **Phase 6**: Final Report
   - Shows design summary
   - Next steps

## Output Files

After completion, you'll have:

```
working-directory/
├── PRD.md          ← Requirements document
├── MOCKUP.md       ← Visual specifications
└── PIP.md          ← Implementation plan
```

## Integration with Skills

Flutter Planner orchestrates these skills:

```
flutter-planner (AGENT)
    ↓
    ├─→ prd-generator (SKILL)
    │   └─→ Creates PRD.md + PIP.md
    │
    └─→ ui-mockup-generator (SKILL)
        └─→ Reads PRD.md
        └─→ Creates MOCKUP.md
```

### Skills Used

1. **prd-generator**
   - Location: `.claude/skills/prd-generator/SKILL.md`
   - Purpose: Generate requirements document
   - Called by: Agent in Phase 3

2. **ui-mockup-generator**
   - Location: `.claude/skills/ui-mockup-generator/SKILL.md`
   - Purpose: Generate visual specifications
   - Called by: Agent in Phase 4

### Skill Configuration

No configuration needed! Agent automatically:
- Passes context to skills
- Prevents redundant questions
- Ensures document consistency

## Customization

### Change Question Depth

Want shorter/longer planning sessions?

Edit `AGENT.md`:
```markdown
### Phase 1: Understanding (5-10 minutes)
```
Change to:
```markdown
### Phase 1: Understanding (3-5 minutes)  # Faster
```

### Add Custom Question Templates

Edit `AGENT.md` under each phase:
```markdown
### Phase 2: Design System

#### Custom Question Template
Add your industry-specific questions here...
```

### Modify Design Options

Edit `AGENT.md` to add your own color palettes, typography styles, etc.:

```markdown
#### Step 2.2: Color Scheme

**Add custom palette:**
```
┌─────────────────────────────────────────┐
│ OPTION: Your Custom Palette             │
│ Primary: #YOUR_HEX                     │
│ Secondary: #YOUR_HEX                   │
│ ...                                    │
└─────────────────────────────────────────┘
```

## Troubleshooting

### Agent Not Loading

**Problem**: Agent doesn't start when I say "Plan my app..."

**Solutions**:
1. Check file location: `.claude/agents/flutter-planner/AGENT.md`
2. Check file syntax: Must be valid markdown
3. Check Claude Code version: Agents supported in v1.0+

### Skills Not Found

**Problem**: Agent says "prd-generator skill not found"

**Solutions**:
1. Verify skills exist:
   ```
   ls .claude/skills/prd-generator/SKILL.md
   ls .claude/skills/ui-mockup-generator/SKILL.md
   ```
2. If missing, create them first (see BuilderPack repo)

### Questions Too Technical

**Problem**: Agent uses jargon I don't understand

**Solutions**:
1. Say: "I don't understand [term]"
2. Agent will simplify explanation
3. Agent adapts to your knowledge level

### Taking Too Long

**Problem**: Planning session is too long

**Solutions**:
1. Say: "Let's use standard defaults to speed up"
2. Agent will skip optional questions
3. Or: "Save progress, continue later"

## Advanced Usage

### Save and Resume

Want to take a break?

```
You: "Save progress"

Agent: "✅ Progress saved!
       Generated so far:
       - Design decisions saved
       - PRD.md created

       Say 'Continue planning' when ready to resume."
```

### Iterate on Existing Documents

Already have PRD? Skip ahead:

```
You: "Continue from my existing PRD"

Agent: "Reading PRD.md...
       Skipping to design phase...
       [Starts Phase 2: Design System]"
```

### Reference Image Analysis

Provide screenshots for inspiration:

```
You: "Plan my app. Here are apps I like:" + [attach 2-3 screenshots]

Agent: [Uses MCP tool to analyze]
       "Based on your screenshots, I notice:
       - Color scheme: [extracts colors]
       - Layout: [identifies pattern]
       - Style: [identifies style]

       Should we use this style?"
```

## Performance Tips

### For Faster Sessions

1. **Come prepared**: Know your app type, target audience
2. **Have references ready**: Screenshots of apps you like
3. **Be decisive**: Pick options when unsure (agent iterates later)
4. **Skip optional questions**: Say "Use defaults"

### For Better Results

1. **Take time on design** (Phase 2): This is where apps succeed
2. **Provide feedback**: Don't just say "ok" - be specific
3. **Ask questions**: If confused, ask for clarification
4. **Use references**: Screenshots help agent understand taste

## Integration with Development Workflow

### Complete Pipeline

```
1. flutter-planner (AGENT)
   ↓ Output: PRD.md, MOCKUP.md, PIP.md
   ↓
2. flutter-creator (SKILL)
   ↓ Input: Reads all 3 documents
   ↓ Output: Flutter code
   ↓
3. flutter-testing (SKILL)
   ↓ Input: Reads PIP.md + code
   ↓ Output: Tests
   ↓
4. Complete App! 🎉
```

### Continuous Iteration

```
Planning → Implementation → Testing → (repeat)
   ↑           ↓              ↓
   └───────────┴──────────────┘
      (update docs as needed)
```

## File Management

### Backup Planning Documents

```bash
# Create backup directory
mkdir app-planning-backup

# Copy documents
cp PRD.md MOCKUP.md PIP.md app-planning-backup/

# Git commit
git add PRD.md MOCKUP.md PIP.md
git commit -m "Complete app planning"
```

### Version Control

Track iterations:
```bash
# After planning
git add PRD.md MOCKUP.md PIP.md
git commit -m "Initial planning complete"

# After design changes
git commit -am "Updated HomeScreen design"

# Always keep planning docs with code
git push
```

## Metrics and Success

### Session Quality Indicators

**Good session**:
- ✅ User said "Perfect!" multiple times
- ✅ Agent adapted questions based on answers
- ✅ User learned something about design
- ✅ All screens approved (not "good enough")
- ✅ User excited about results

**Needs improvement**:
- ❌ User seemed fatigued
- ❌ Agent asked too many questions
- ❌ Design feels generic
- ❌ User settled instead of loved

**Time targets**:
- Simple app: 45-50 min
- Medium app: 55-65 min
- Complex app: 65-80 min

## Support

### Issues? Questions?

1. Check this file first
2. Read `README.md` for detailed guide
3. See `examples/session-transcript.md` for example
4. Review BuilderPack main README

### Feature Requests

Want to improve Flutter Planner?

1. Identify what would help
2. Edit `AGENT.md` to add features
3. Test with example session
4. Share improvements with community

## Summary

**Flutter Planner is ready when you are!**

Just say: "Plan my [app] completely"

**What you get**:
- Beautiful, cohesive design
- Complete PRD, mockups, implementation plan
- Educational experience (learn design principles)
- Excitement about your app! 🎉

**Time investment**: 45-70 minutes
**Value returned**: Priceless (your app will actually be beautiful)

**Ready? Let's create something amazing!** 🚀
