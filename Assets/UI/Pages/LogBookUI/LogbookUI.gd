extends BookMenu
class_name LogbookUI

## Mission journal.
##
## [b]TODO:[/b][br]
## [u]Initial load:[/u][br]
## 1) Retrieve all given tasks from a "Tasks"/"Goals" resource[br]
## 2) Add one [code]LogbookUIPage[/code] scene per task into [LogbookUI][br]
## 3) Check accomplishment status and make only pages of completed tasks
##    and the latest one visible[br]
##    (usually 1st page only when new game, and more when loading a save file)[br]
## [br]
## [u]Side requirements:[/u][br]
## On opening:[br]
## Always start at the last visible page (= latest task)[br]
## [br]
## [u]Resource format:[/u][br]
## Caption[br]
## Body - should be able to store text and images
