Class NYTaxi.Zones Extends %Persistent [ DdlAllowed, Final, SqlRowIdPrivate ]
{

Property ObjectID As %Integer [ SqlColumnNumber = 8 ];

Property LocationID As %Integer [ SqlColumnNumber = 2 ];

Property Zone As %String(MAXLEN = 300) [ SqlColumnNumber = 3 ];

Property Borough As %String(MAXLEN = 300) [ SqlColumnNumber = 4 ];

Property ShapeLength As %Double [ SqlColumnNumber = 5, SqlFieldName = Shape_Length ];

Property ShapeArea As %Double [ SqlColumnNumber = 6, SqlFieldName = Shape_Area ];

Property Geometry As %String(MAXLEN = "") [ SqlColumnNumber = 7 ];

Index LocationID On LocationID [ PrimaryKey, Unique ];

Storage Default
{
<Data name="ZonesDefaultData">
<Value name="1">
<Value>ObjectID</Value>
</Value>
<Value name="2">
<Value>LocationID</Value>
</Value>
<Value name="3">
<Value>Zone</Value>
</Value>
<Value name="4">
<Value>Borough</Value>
</Value>
<Value name="5">
<Value>ShapeLength</Value>
</Value>
<Value name="6">
<Value>ShapeArea</Value>
</Value>
<Value name="7">
<Value>Geometry</Value>
</Value>
</Data>
<DataLocation>^NYTaxi.ZonesD</DataLocation>
<DefaultData>ZonesDefaultData</DefaultData>
<IdLocation>^NYTaxi.ZonesD</IdLocation>
<IndexLocation>^NYTaxi.ZonesI</IndexLocation>
<StreamLocation>^NYTaxi.ZonesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
