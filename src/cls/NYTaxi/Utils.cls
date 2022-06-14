Class NYTaxi.Utils
{

ClassMethod Truncate() As %Status
{
    do ..Start()
    &SQL(TRUNCATE TABLE NYTaxi.Rides)
    &SQL(TRUNCATE TABLE NYTaxi.RowRides)
    &SQL(TRUNCATE TABLE NYTaxi.Zones)
    do ..Stop()
    quit $$$OK
}

ClassMethod Load(directory As %String) As %Status
{
    do ..Start()
    set sc = $$$OK
    try {

        for table = "NYTaxi.Rides", "NYTaxi.RowRides" {
            do ..Log("Loading data for table "_table)
            set tt = $zh

            quit:..SQL("Fetching directory listing for "_directory, "CALL %Library.File_FileSet(?,'yellow_*.csv')", .rs, directory)
            while rs.%Next() {
                set sql = "LOAD BULK %NOJOURN DATA FROM FILE '"_rs.%Get("Name")_"' INTO "_table_" USING '{ ""from"": {""file"": {""columnseparator"":"","", ""header"": true } } }'"
                quit:..SQL("Loading file "_rs.%Get("ItemName"), sql)
            }
            //quit:..SQL("Building indices","BUILD INDEX FOR TABLE "_table)
            do ..Log("Finished loading "_table_" in "_$fnumber($zh-tt,"",2)_"s")
            do ..Log()

            do ..SQL("Gathering table sizes", "CALL bdb_sql.TableSize(?)", .rs, table)
            do rs.%Display()
            do ..Log()
        }

        set separator = $s($$$isWINDOWS:"\", 1:"/")
        set zonesFile = directory_$s($e(directory,*)=separator:"", 1:separator)_"taxi_zones.csv"
        do ..SQL("Loading taxi zones from "_zonesFile, "LOAD BULK %NOJOURN DATA FROM FILE '"_zonesFile_"' COLUMNS (ObjectID INT, Shape_Length DOUBLE, Geometry CLOB, Shape_Area DOUBLE, Zone VARCHAR(300), LocationID INT, borough VARCHAR(300)) INTO NYTaxi.Zones")   
        
    } catch (ex) {
        set sc = ex.AsStatus()
    }
    do ..Stop(sc)
    quit sc
}

ClassMethod Start(args...) [ Internal, Private ]
{
    do ..Log()
    // figure out current method from stack
    set spec = $lg($zu(41,-2),2),
        class = $p($p(spec,"^",3),".",1,*-1),
        method = $e($p($p(spec,"^",2),"+",1),2,*)
    set argstr = ""
    for i = 1:1:$g(args) {
        set argstr = argstr _ $s(i>1:", ", 1:"") _ $$$QUOTE($s($l(args)>100:$e(args(i),1,99)_"...", 1:args(i)))
    }
    do ..Log("Calling ##("_class_")."_method_"("_argstr_")", "DEBUG")
}

ClassMethod Stop(sc As %Status = {$$$OK}) [ Internal, Private ]
{
    // figure out current method from stack
    set spec = $lg($zu(41,-2),2),
        class = $p($p(spec,"^",3),".",1,*-1),
        method = $e($p($p(spec,"^",2),"+",1),2,*)
    do ..LogError(sc, "End of ##("_class_")."_method_"()", "DEBUG")
    do ..Log()
}

/// Returns 1 if an error was encountered
ClassMethod LogError(sc As %Status, message As %String = "", level As %String = "INFO") As %Boolean [ Internal ]
{
    if $g(message)'="" {
        do ..Log(message_" - "_$s($$$ISOK(sc):"OK", 1:"ERROR"), level)
    }
    quit:$$$ISOK(sc) 0
    do ..Log($system.Status.GetErrorText(sc), "ERROR")
    quit 1
}

/// Returns 1 if an error was encountered
ClassMethod SQL(description As %String, sql As %String, Output rs, args...) As %Boolean [ Internal ]
{
    set stmt = ##class(%SQL.Statement).%New(),
        stmt.%SelectMode = 2
    do ..Log("Running SQL Statement: "_description_":"_$c(13,10)_sql)
    quit:..LogError(stmt.%Prepare(sql),"Preparing "_description) 1
    set t = $zh
    set rs = stmt.%Execute(args...)
    if rs.%SQLCODE >= 0 {
        do ..Log(description_" executed successfully in "_($zh-t)_"s - "_rs.%ROWCOUNT_" rows affected")
        quit 0
    } else {
        do ..Log("Error executing "_description_": "_rs.%Message, "ERROR")
        quit 1
    }
}

ClassMethod Log(message As %String = "", level As %String = "INFO") [ Internal ]
{
    if $g(message)="" {
        set line = ""
    } else {
        set line = $zdt($h)_" - "_level_": "_message
    }
    write !,line
    try {
        set file = ##class(%Stream.FileCharacter).%New()
        do file.LinkToFile(..#LOGFILE), file.MoveToEnd()
        do file.WriteLine(line)
        do file.%Save()
    } catch {}
}

Parameter LOGFILE = "ColumnarTesting.log";

ClassMethod GloRefs() As %Integer [ SqlName = GloRefs, SqlProc ]
{
    quit $zu(61,43,$zu(61)) + $SYSTEM.Context.WorkMgr().GlobalReferences
}

}
