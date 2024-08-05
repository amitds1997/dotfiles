# AGS configuration

Continue with fixing `workspace` widget buttons disappearing

## Workspace logic

When hideEmpty is `true`:

- Show workspaces either active or that are occupied

When hideEmpty is `false`:

- Show all workspaces
- For each consecutive occupied workspaces, group them

If either `hideEmpty` changes or workspaces change, re-run the grouping algorithm

Each workspace button would also decide if it wants to be shown on a particular monitor.
