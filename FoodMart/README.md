# FoodMart

iOS food marketplace app with category filtering and grid display built with SwiftUI

## Features

- Browse produce items in a 2-column grid layout
- Filter items by category using toggles
- View item details including name, price, category, and image
- Loading states with progress indicator
- Error handling with retry functionality
- Responsive design that works across different iPhone sizes

## Requirements

- iOS 18+
- Swift 6+

## Installation

1. Clone the repository
```bash
git clone https://github.com/designalkhemy/FoodMart.git
```

2. Open 'FoodMart.xcodeproj' in Xcode

3. Build and run (Cmd + R)

## Architecture

- **SwiftUI** for declarative UI
- **URLSession** with async/await for network requests
- **MVVM pattern** with ViewModel for business logic
- **State management** using enums for loading states
- **Set-based filtering** for efficient category selection
- **Dictionary lookups** for O(1) category name retrieval

## Project Structure

The project follows MVVM architecture:

- **Models**: `FoodItem`, `Category`, `LoadState` - Data structures and state enums
- **ViewModels**: `ContentViewModel` - Business logic and data fetching
- **Views**: `ContentView`, `FoodItemCard`, `FilterView` - SwiftUI views
- **Tests**: Unit tests for filtering and data loading logic

## Testing

### Unit Tests

I wrote unit tests to verify core functionality using Swift Testing framework:

**Test Coverage:**
- ✅ ViewModel initializes with correct initial state
- ✅ Data loads successfully from both APIs
- ✅ Filtering with no selection displays all items
- ✅ Filtering with single category displays only matching items
- ✅ Filtering with multiple categories displays items from any selected category
- ✅ Filtering with all categories selected displays all items

**Run tests:**
```bash
Cmd+U in Xcode
```

All tests pass successfully.

### Manual Testing

I also performed manual testing to verify UI behavior:

**Data Loading:**
- ✅ App launches and displays loading indicator
- ✅ Data fetches successfully from both API endpoints
- ✅ Grid populates with produce items
- ✅ Images load asynchronously with placeholders

**Grid Display:**
- ✅ Items display in 2-column grid layout
- ✅ Each card shows image, name, price, and category
- ✅ Grid scrolls smoothly with proper spacing
- ✅ Layout adapts correctly on iPhone SE, iPhone 15, and iPhone 15 Pro Max

**Category Filtering:**
- ✅ Filter button opens category selection sheet
- ✅ Sheet displays at 1/3 screen height with rounded corners
- ✅ All categories display as toggles in alphabetical order
- ✅ Toggling single category filters grid correctly
- ✅ Toggling multiple categories shows union of matching items
- ✅ Deselecting all categories returns to showing all items
- ✅ Filter state persists when sheet is dismissed and reopened

**Error Handling:**
- ✅ Network failure displays error screen (tested by disabling WiFi)
- ✅ Error message displays clearly with icon
- ✅ Retry button appears and is functional
- ✅ Retry successfully refetches data when connection restored
- ✅ Invalid image URLs display gray placeholder gracefully

**Edge Cases:**
- ✅ Missing category data defaults to "Unknown"
- ✅ Empty produce list handled appropriately
- ✅ Rapid filter toggling works without crashes


## Implementation Details

**Key Design Decisions:**

- Used `Set<String>` for selected categories to enable O(1) membership checks during filtering
- Implemented dictionary lookup for category names to avoid O(n) searches
- Used computed property for filtered items to maintain single source of truth
- Employed enum-based state management for clear loading/error/success states
- Used `URL` type for image URLs to ensure type safety during decoding

## Time Spent

Approximately 4-5 hours including:
- Project setup and architecture
- Data fetching and model implementation
- UI implementation with filtering
- Unit test writing
- Error handling and polish
- Documentation

---

Built as a take-home assessment project.

