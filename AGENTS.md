# PhraseSync Agent Guide

This document provides an overview of the PhraseSync Obsidian plugin for AI agents tasked with developing or maintaining this project.

## 1. Project Purpose & Vision

**PhraseSync** is an Obsidian plugin designed to make internal linking effortless and intelligent. Unlike traditional auto-complete that triggers on specific characters (e.g., `[[`), PhraseSync works in real-time, mid-sentence, to suggest links based on phrases you're naturally typing.

The core vision is to bridge the gap between writing and linking, allowing users to connect ideas seamlessly without interrupting their flow. It should feel like the vault is proactively suggesting connections.

**Key Goals:**
- **Frictionless Linking:** Automatically detect potential linkable phrases (note titles, headings, block IDs) as the user types.
- **Real-Time Indexing:** The plugin must always be aware of the vault's current state. Any new note, heading, or change should be reflected in suggestions almost instantly.
- **Intelligent Matching:** Go beyond simple keyword matching. The plugin should handle multi-word phrases, be case-insensitive, and use smart logic to determine the most relevant suggestions.
- **Performance:** Maintain a low-latency experience, even in very large vaults. Indexing and suggestion lookups must be highly optimized.

## 2. Core Architecture

The plugin is written in TypeScript and built upon the Obsidian API. The architecture is centered around a live index and a smart suggestion engine.

### `main.ts` - The Core Components

This file contains the primary classes and logic.

#### a. `PhraseSync` (Main Plugin Class)

- **Role:** The entry point and orchestrator of the plugin.
- **Responsibilities:**
    - Manages the plugin's lifecycle (`onload`, `onunload`).
    - Initializes the index and registers the suggestion engine.
    - **Crucially, it sets up event listeners for vault changes.** It listens for file creation, deletion, modification, and renaming events. This is fundamental to keeping the index alive and accurate.

#### b. The Index (`index: Map<string, IndexEntry[]>`)

- **Role:** The brain of the plugin. It holds the entire corpus of linkable items.
- **Structure:** It's a `Map` where:
    - **Key (`string`):** A *normalized* version of the text to be matched (e.g., a note title, heading). Normalization involves converting to lowercase and removing special characters to ensure robust matching.
    - **Value (`IndexEntry[]`):** An array of objects containing detailed information about the link target (its type, path, display text, etc.). It's an array because multiple items might share the same normalized key (e.g., a heading with the same name in different notes).
- **Lifecycle:**
    1.  **`buildFullIndex()`:** Called on startup to perform an initial scan of the entire vault.
    2.  **Incremental Updates:** After the initial build, the index is kept in sync via the event handlers (`debouncedIndexUpdate`, `deleteFromIndex`, `renameInIndex`). These methods ensure minimal, targeted updates for maximum performance.

#### c. `PhraseSyncSuggest` (Suggestion Engine)

- **Role:** The user-facing component that provides suggestions in the editor.
- **Inheritance:** Extends `EditorSuggest<IndexEntry>` from the Obsidian API.
- **Key Methods:**
    - **`onTrigger()`:** This is the most sophisticated part of the logic. It's called continuously as the user types and moves the cursor. Its job is to decide *if* and *what* to suggest. It analyzes the text around the cursor to identify multi-word phrases, checks if those phrases exist in the index, and then returns a query context.
    - **`getSuggestions()`:** Takes the query from `onTrigger` and fetches matching entries from the main `index`. It uses a combination of exact-prefix and fuzzy matching to provide relevant results.
    - **`renderSuggestion()`:** Formats how each suggestion looks in the UI pop-up.
    - **`selectSuggestion()`:** Executes when the user selects an item. It replaces the typed text with a correctly formatted Obsidian link.

## 3. Development Workflow

1.  **Dependencies:** Run `npm i` to install the required packages (like the Obsidian API types).
2.  **Building:** Run `npm run build` to compile the TypeScript code into `main.js`. This uses `esbuild` for fast bundling.
3.  **Testing:**
    - To test changes, copy the generated `main.js`, along with `manifest.json` and `styles.css`, into the `.obsidian/plugins/phrasesync/` directory of a local test vault.
    - Reload Obsidian or disable/enable the plugin to see your changes.
4.  **Code Style:** The project uses Prettier for code formatting. Ensure you format your code before committing.

## 4. Key Files

- `main.ts`: The heart of the plugin, containing all core logic.
- `manifest.json`: Defines the plugin's metadata for Obsidian.
- `package.json`: Lists dependencies and build scripts.
- `esbuild.config.mjs`: Configuration for the `esbuild` bundler.
- `README.md`: Public-facing documentation.
