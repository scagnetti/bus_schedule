BusStop.create!([
  {display_name: "Graß", search_name: "Regensburg, Graß", direction_id: 1},
  {display_name: "Brunnstraße", search_name: "Regensburg, Graß Brunnstraße", direction_id: 1},
  {display_name: "Fernsehsender Ziegetsdorf", search_name: "Regensburg, Fernsehsender Ziegetsdorf", direction_id: 1},
  {display_name: "Graßer Weg", search_name: "Regensburg, Graßer Weg", direction_id: 1},
  {display_name: "Karl-Stieler-Straße", search_name: "Regensburg, Karl-Stieler-Straße", direction_id: 1},
  {display_name: "Geibelplatz", search_name: "Regensburg, Geibelplatz", direction_id: 1},
  {display_name: "Wolfgangschule Süd", search_name: "Regensburg, Wolfgangschule Süd", direction_id: 1},
  {display_name: "Theodor-Storm-Straße", search_name: "Regensburg, Theodor-Storm-Straße", direction_id: 1},
  {display_name: "Augsburger Straße", search_name: "Regensburg, Augsburger Straße", direction_id: 1},
  {display_name: "Theresienkirche", search_name: "Regensburg, Theresienkirche", direction_id: 1},
  {display_name: "Justizgebäude", search_name: "Regensburg, Justizgebäude", direction_id: 1},
  {display_name: "Bismarckplatz", search_name: "Regensburg, Bismarckplatz", direction_id: 1},
  {display_name: "Arnulfsplatz", search_name: "Regensburg, Arnulfsplatz", direction_id: 1},
  {display_name: "Keplerstraße", search_name: "Regensburg, Keplerstraße", direction_id: 1},
  {display_name: "Fischmarkt", search_name: "Regensburg, Fischmarkt", direction_id: 1},
  {display_name: "Thundorferstraße", search_name: "Regensburg, Thundorferstraße", direction_id: 1},
  {display_name: "Dachauplatz", search_name: "Regensburg, Dachauplatz", direction_id: 1},
  {display_name: "Albertstraße", search_name: "Regensburg, HBF/Albertstraße", direction_id: 1}
])
Direction.create!([
  {display_name: "Schwabenstraße", search_name: "Regensburg Schwabenstraße", bus_line_id: 1},
  {display_name: "Karl-Stieler-Straße", search_name: "Regensburg Karl-Stieler-Straße", bus_line_id: 1}
])
BusLine.create!([
  {name: "Linie2AB"}
])
