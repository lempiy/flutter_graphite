## [0.1.0] - July 18, 2020.

* Initial widget version.
* Nodes and edge gesture events.
* Ability provide graph building direction (horizontal or vertical).
* Ability provide scrolling direction (horizontal, vertical, both or none).
* Ability to provide custom builder to node widget.
* Ability to provide custom paint builder to graph edges.
* Ability to customize arrows.

## [0.1.1] - July 18, 2020.

* Code style fixes.

## [0.2.0] - August 29, 2020.

* Ability to scale & pan graph through Interactive Widget.
* Removed ScrollDirection enum (replaced ScrollViews with Interactive Widget).
* Added ability to customize path shape with pathBuilder param.

## [0.2.3] - December 16, 2020

* Core lib bug fixes

## [0.3.0-alpha] - April 29, 2021

* Initial null safety support

## [0.3.0-beta] - April 30, 2021

* Fix edges shift bug as a result of grid view non-zero padding

## [0.3.0] - May 13, 2021

* Use arrow_path v2.0, skip own fork

## [1.0.0] - December 11, 2022

* Param `cellSize` changed to `defaultCellSize` with `Size` type. Now it's possible to create non-square nodes. [#16](https://github.com/lempiy/flutter_graphite/issues/16)
* Each node input now has `size` param allowing `defaultCellSize` override for particular nodes. [#15](https://github.com/lempiy/flutter_graphite/issues/15)
* Node gestures know also have rect (`Rect`) as param, with info about node's position on `Stack`.
* Ability to set `centered` node outcomes to provide more pretty graph rendering for tree-like graphs. [#2](https://github.com/lempiy/flutter_graphite/issues/2)
* Ability to add overlays with `overlayBuilder` param.
* Ability to add edge text or `Widget` labels using `edgeLabels` param. [#13](https://github.com/lempiy/flutter_graphite/issues/13)
* Ability to wrap `InteractiveViewer` content with custom widget using `contentWrapperBuilder`.
* Ability to draw double-headed arrows on edges or without arrows on edges via `EdgeInput.type`. [#4](https://github.com/lempiy/flutter_graphite/issues/4)
* Added `clipBehavior`, `transformationController` as new params.
* Fixed bugs with non-firing edge gestures and increased edges hitbox to improve UX. [#10](https://github.com/lempiy/flutter_graphite/issues/10) [#14](https://github.com/lempiy/flutter_graphite/issues/14)
* More examples.
* Many fixes and improvements for more compact graph rendering.

## [1.1.0] - March 9, 2023

* Removed internal `InteractiveViewer` dependency. Content boundaries, scrolls or `InteractiveViewer` usage are now on applications responsibility. [#20](https://github.com/lempiy/flutter_graphite/issues/20)
* Removed `transformationController` since `InteractiveViewer` is no longer used.
* Removed `contentWrapperBuilder` since `InteractiveViewer` is no longer used.
* Changed `onCanvasTap` callback to provide tap details and trigger only if tapped out of other widgets and figures.

## [1.1.1] - April 27, 2023

* Removed max iterations limitation for graph.

## [1.1.2] - May 12, 2023

* Fixed complexity bug with node relations detection.
