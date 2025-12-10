# UAT Checklist Guidelines

Generate User Acceptance Testing (UAT) checklists covering functional flows, SDS compliance, accessibility, role-based scenarios, and edge cases for staging validation.

## Responsibilities

1. **Functional scenarios**:
   - Happy path: Primary user flows work as expected.
   - Edge cases: Empty states, single item, many items, boundary values.
   - Error handling: Invalid input, network failures, timeouts.

2. **Role-based testing**:
   - Root user: All operations accessible and working.
   - SAM user: Restricted operations properly hidden/disabled/error.

3. **SDS compliance**:
   - Components match design: Table, Card, Form, Modal, etc.
   - Spacing and layout match SDS guidelines (8px base).
   - Visual consistency with existing console areas.

4. **Accessibility**:
   - Keyboard navigation: Tab order logical, Enter/Escape work.
   - Screen reader: Labels present, error messages announced.
   - Color contrast: Meets WCAG AA standards.

5. **Internationalization**:
   - Japanese and English strings display correctly.
   - Dates, numbers, currencies formatted per locale.

6. **Performance and UX**:
   - Loading states: Skeletons or spinners appear appropriately.
   - Error messages: Clear, actionable, non-technical.
   - Success feedback: Toasts or banners confirm actions.

7. **Cross-browser/device**:
   - Chrome, Firefox, Safari (latest versions).
   - Desktop and tablet viewports (mobile if applicable).

## UAT Checklist Structure

```markdown
# UAT Checklist: <Feature Name>

**PRD**: `outputs/<date>-<slug>.md`
**Environment**: Staging
**Test Date**: YYYY-MM-DD
**Tester**: <Name>
**Status**: ⬜ Not Started | 🟡 In Progress | ✅ Passed | ❌ Failed

---

## Functional Scenarios

### Happy Path
- [ ] **As Root**: Create new group with valid inputs
  - Navigate to Groups > Create
  - Fill form: Name="Test Group", Tags="QA"
  - Submit
  - **Expected**: Success toast, group appears in list
- [ ] **As Root**: Edit existing group
  - Navigate to group detail
  - Click Edit, update description
  - Save
  - **Expected**: Changes reflected, success toast
- [ ] **As Root**: Delete group
  - Navigate to group detail
  - Click Delete, confirm modal
  - **Expected**: Group removed from list, success toast

### SAM User Restrictions
- [ ] **As SAM**: Create button hidden or disabled
  - Navigate to Groups
  - **Expected**: Cannot see or click Create
- [ ] **As SAM**: Edit attempt shows error
  - Navigate to group detail (if accessible)
  - **Expected**: Edit button disabled or 403 error on attempt
- [ ] **As SAM**: Delete attempt shows error
  - **Expected**: Delete button disabled or clear permission message

### Edge Cases
- [ ] Empty state: No groups exist
  - **Expected**: Shows empty state with "Create Group" CTA
- [ ] Single item: Exactly 1 group
  - **Expected**: List displays correctly, pagination hidden
- [ ] Many items: 100+ groups
  - **Expected**: Pagination works, <200ms load time, no UI jank
- [ ] Boundary values:
  - [ ] Group name: 1 character (if allowed)
  - [ ] Group name: Maximum length (e.g., 255 chars)
  - [ ] Special characters in name: `Test-Group_123`

### Error Handling
- [ ] Invalid input: Empty group name
  - **Expected**: Inline error "Name is required", submit disabled
- [ ] Duplicate name
  - **Expected**: API returns 409, inline error "Group name already exists"
- [ ] Network failure: Disconnect wifi mid-creation
  - **Expected**: Timeout error, retry option or clear message
- [ ] Server error: Backend returns 500
  - **Expected**: Generic error toast, does not expose stack trace

---

## SDS Compliance

### Component Usage
- [ ] **Table**: Uses SDS Table component
  - Columns: Name, Tags, Created, Actions
  - Toolbar with filters and search
  - Pagination at bottom
- [ ] **Form**: Uses SDS FormField + ValidationMessage
  - Labels aligned left
  - Validation errors inline below fields
- [ ] **Modal**: Uses SDS Modal for delete confirmation
  - Heading, body text, Cancel/Delete buttons
  - Escape key closes modal

### Layout & Spacing
- [ ] Card padding: 24px internal spacing
- [ ] Card stacking: 24px vertical separation
- [ ] Table: Full width, actions column right-aligned
- [ ] Form: 16px spacing between fields

### Visual Consistency
- [ ] Colors match existing console areas
- [ ] Typography follows SDS (font family, sizes, weights)
- [ ] Icons from SDS icon library

---

## Accessibility

### Keyboard Navigation
- [ ] Tab order: Logical flow through form fields and actions
- [ ] Enter key: Submits form (when appropriate)
- [ ] Escape key: Closes modals and dismisses toasts
- [ ] Arrow keys: Navigate table rows (if implemented)

### Screen Reader
- [ ] Form labels: Associated with inputs via `for` or `aria-labelledby`
- [ ] Error messages: Announced when validation fails
- [ ] Success toasts: Announced with `role="alert"`
- [ ] Modal focus: Trapped within modal when open, restored on close

### Color Contrast
- [ ] Text on background: Meets WCAG AA (4.5:1)
- [ ] Interactive elements: Sufficient contrast for hover/focus states
- [ ] Error messages: Color plus icon (not color alone)

---

## Internationalization

### Japanese (ja-JP)
- [ ] All UI strings in Japanese
- [ ] Dates formatted: YYYY年MM月DD日
- [ ] Numbers: Comma separator for thousands (1,234)
- [ ] Error messages in Japanese

### English (en-US)
- [ ] All UI strings in English
- [ ] Dates formatted: MM/DD/YYYY
- [ ] Numbers: Comma separator (1,234)
- [ ] Error messages in English

### Locale Switching
- [ ] Switching locale reloads strings without page refresh (if SPA)
- [ ] No mixed languages in UI

---

## Performance & UX

### Loading States
- [ ] Initial page load: Skeleton or spinner appears
- [ ] Form submit: Button shows loading spinner, disabled during submit
- [ ] Table data fetch: Inline spinner or skeleton rows

### Feedback
- [ ] Success: Green toast with checkmark icon
- [ ] Error: Red toast or inline alert with error icon
- [ ] Confirmation: Modal with clear consequence text for destructive actions

### Responsiveness
- [ ] Desktop (1920x1080): Layout comfortable, no horizontal scroll
- [ ] Tablet (768x1024): Layout adapts, no overflow
- [ ] Mobile (375x667) if applicable: Mobile-optimized or graceful degradation

---

## Cross-Browser

- [ ] Chrome (latest): All features work
- [ ] Firefox (latest): All features work
- [ ] Safari (latest): All features work
- [ ] Edge (latest): All features work (optional)

---

## Regression Checks

- [ ] Existing groups still load and display correctly
- [ ] Existing workflows (SIM management, billing, etc.) not broken
- [ ] Navigation and global search still work

---

## Sign-Off

- [ ] **Functional**: All scenarios passed
- [ ] **SDS**: Components and layout compliant
- [ ] **Accessibility**: Keyboard and screen reader tests passed
- [ ] **I18n**: Japanese and English verified
- [ ] **Performance**: Load times acceptable
- [ ] **Cross-browser**: Tested on Chrome + Firefox + Safari

**Approved by**: ___________________
**Date**: YYYY-MM-DD
**Notes**: <Any observations, minor issues deferred to post-release>
```

## Process

1. **Parse PRD**:
   - Extract functional requirements (what the feature does).
   - Identify user roles (Root, SAM, etc.).
   - Note any SDS components mentioned in UX evidence.

2. **Map to checklist items**:
   - For each FR, create happy path and edge case checks.
   - Add role-specific scenarios.
   - Include SDS compliance checks based on components used.

3. **Add non-functional checks**:
   - Accessibility (keyboard, screen reader, contrast).
   - I18n (Japanese, English).
   - Performance (load times, large data sets).

4. **Save output**:
   - Write to `outputs/<slug>/uat.md`.
   - Link from PRD under "UAT Checklist" section.

## Failure Handling

- **Missing PRD or UX evidence**: Generate generic checklist and mark TODOs.
- **Unknown components**: Ask for SDS component details before generating compliance checks.
- **Unclear roles**: Request explicit Root/SAM permission rules.

## Integration with SAEF Workflow

- **Triggered by**: `/saef:uat` command
- **Prerequisites**: PRD completed, UX evidence available
- **Next step**: QA executes checklist in staging, reports results

## Style Rules

- Use checkboxes `- [ ]` for actionable items.
- Group related checks under headings.
- Include **Expected** outcomes for clarity.
- Reference specific SDS components when known.

## Example Triggers

- "Generate a UAT checklist for the group export feature"
- "/saef:uat"
- "What should QA test for this feature in staging?"
