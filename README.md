# Slay the Spire 2 Auto Splitter

Slay the Spire 2 Auto Splitter that reads from the `godot.log` file. I adapted [Oohbleh's Slay the Spire 1 auto splitter](https://github.com/OohBleh/Spire-speedruns-and-other-stuff/blob/main/autosplitters/broken/LiveSplit.SlayTheSpire2.asl) for this.

## Setup

1. Download `LiveSplit.SlayTheSpire2.asl` and save it somewhere.
2. Open up your LiveSplit, right-click it, and hit Edit Layout...
3. In your LiveSplit layout, click the + and add the Control > Scriptable Auto Splitter component.
4. Double click Scriptable Auto Splitter and enter the path to `LiveSplit.SlayTheSpire2.asl`.

The auto splitter should now work. Out of the box there's some settings toggled on for starting the timer on run start, splitting on boss kill, and resetting on deaths/abandon (also a setting on resetting on game close that's toggled off initially). These settings are currently mostly applicable to single runs, but in the future I can add additional settings more suited for multi-run long categories.
