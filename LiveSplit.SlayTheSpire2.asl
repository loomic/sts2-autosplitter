/*
    adapted from Oohbleh's Slay the Spire 1 autosplitter -
    https://github.com/OohBleh/Spire-speedruns-and-other-stuff/blob/main/autosplitters/broken/LiveSplit.SlayTheSpire2.asl 
*/

state("SlayTheSpire2") {}

startup
{
    vars.Log = (Action<object>)(output => print("[Slay the Spire 2] " + output));
    vars.TryMatch = (Func<string, string, string>)((value, regex) =>
    {
        var match = System.Text.RegularExpressions.Regex.Match(value, regex);
        if (match.Success){
			return match.Groups[1].Value;
		} else{
			return;
		}

    });

    dynamic[,] _settings =
    {
        { null, "startSeed",    "Start when generating a new seed", true },
        { null, "resetDeath",   "Reset on deaths/abandons", true },
		{ null, "resetClose",   "Reset when game closes", false },
        { null, "bosses",       "Split when defeating a boss", true },


        // { null, "splitLvlChange",   "Split on ascension progression",                                  false },
        // { null, "startSlot",        "Start when choosing a new save slot",                             false },
        // { null, "deleteSlot",       "Reset when deleting a new save slot",                             false },
    };

    for (int i = 0; i < _settings.GetLength(0); i++)
    {
        var parent = _settings[i, 0];
        var id     = _settings[i, 1];
        var name   = _settings[i, 2];
        var state  = _settings[i, 3];

        settings.Add(id, state, name, parent);
    }
}

init
{
    var log = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\SlayTheSpire2\logs\godot.log";
    try
    {
        vars.Reader = new StreamReader(new FileStream(log, FileMode.Open, FileAccess.Read, FileShare.ReadWrite));
        vars.Reader.ReadToEnd();
    }

    catch
    {
		vars.Log("Cannot open Slay the Spire 2 log!");
        vars.Log(Path.GetFullPath(log));
        vars.Reader = null;
    }
    current.Line = "";
	current.LinesInLog = 0;
}

update
{
	
	if (vars.Reader == null){
        return false;
	}
	
    current.Line = vars.Reader.ReadLine();
	
    // Check whether file contents were reset.
    current.LinesInLog = vars.Reader.BaseStream.Length;
    if (old.LinesInLog > current.LinesInLog)
    {
		vars.Reader.BaseStream.Position = 0;
        return false;
    }
}

start
{
    // If the line didn't change or we're at the end of the file, we don't care.
    // For convenience.
    var l = current.Line;

    if (old.Line == l || l == null) return;

    if (settings["startSeed"])
    {
        return l.Contains("Embarking on a");
    }
}

split
{
    var l = current.Line;
	if (old.Line == l || l == null) return;

    // Split for boss kills.
    string boss = vars.TryMatch(l, "(CHARACTER.* has won against encounter ENCOUNTER.*_BOSS|CHARACTER.* fought ENCOUNTER.*_BOSS for the first time and WON)");
    if (boss != null)
    {
        return settings["bosses"];
    }
}

reset
{
    var l = current.Line;
	
	if (old.Line == l || l == null) return;

	if (l.Contains("Abandoning an in-progress run (player-initiated)") || l.Contains("has lost to encounter") || l.Contains("Abandoning run from main menu")){
		vars.HasKilledBoss = false;
        return settings["resetDeath"];
    }
}

exit
{
    if (settings["resetClose"]){
		vars.Reader.Close();
	}
}

shutdown
{
    vars.Reader.Close();
}