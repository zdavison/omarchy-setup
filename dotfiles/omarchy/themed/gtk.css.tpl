/* Omarchy colours for GTK4/libadwaita apps (Nautilus etc.).
   Rendered by Omarchy on every theme change; ~/.config/gtk-4.0/gtk.css links to the result. */

:root {
  --accent-bg-color: {{ accent }};
  --accent-color: {{ accent }};
  --accent-fg-color: {{ background }};

  --window-bg-color: {{ background }};
  --window-fg-color: {{ foreground }};

  --view-bg-color: {{ background }};
  --view-fg-color: {{ foreground }};

  --headerbar-bg-color: {{ dark_background }};
  --headerbar-fg-color: {{ foreground }};
  --headerbar-backdrop-color: {{ background }};
  --headerbar-border-color: {{ muted }};

  --sidebar-bg-color: {{ dark_background }};
  --sidebar-fg-color: {{ foreground }};
  --sidebar-backdrop-color: {{ background }};
  --sidebar-border-color: {{ muted }};
  --secondary-sidebar-bg-color: {{ dark_background }};
  --secondary-sidebar-fg-color: {{ foreground }};

  --card-bg-color: {{ lighter_background }};
  --card-fg-color: {{ foreground }};

  --popover-bg-color: {{ lighter_background }};
  --popover-fg-color: {{ foreground }};

  --dialog-bg-color: {{ lighter_background }};
  --dialog-fg-color: {{ foreground }};

  --destructive-bg-color: {{ red }};
  --destructive-color: {{ red }};
  --success-bg-color: {{ green }};
  --success-color: {{ green }};
  --warning-bg-color: {{ yellow }};
  --warning-color: {{ yellow }};
  --error-bg-color: {{ red }};
  --error-color: {{ red }};
}
