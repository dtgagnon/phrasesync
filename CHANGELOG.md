## [1.2.0] – YYYY-MM-DD

### 🚀 New Feature

- **Automatic self-reload on startup**  
	- Eliminates the need to manually disable and re-enable the plugin each time Obsidian launches.  
	- After the full index build completes, `safeReload()` is invoked **once** per session to ensure PhraseSync is fully active.  
	- Uses an in-memory session flag (`window.phraseSyncInitialized`) to guard against repeated reload loops.

### 🔧 Technical Details

- **One-time reload guard**  
	- Reload logic is tucked into the `onload()` lifecycle *after* indexing finishes, rather than at load-start.  
	- A transient session flag prevents any further reloads until the next Obsidian restart.

- **Minimal performance impact**  
	- The reload is deferred until after indexing, so it does not block initial suggestion availability.  
	- Session-only flag and single reload call incur negligible CPU/memory overhead.