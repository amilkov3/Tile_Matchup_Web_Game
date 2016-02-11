capitalsToStates = [
	["Montgomery", "Alabama"],
	["Juneau", "Alaska"],
	["Phoenix", "Arizona"],
	["Little Rock", "Arkansas"],
	["Sacramento", "California"],
	["Trenton", "New Jersey"],
	["Denver", "Colorado"],
	["Santa Fe", "New Mexico"],
	["Hartford", "Connecticut"],
	["Albany", "New York"],
	["Dover", "Delaware"],
	["Raleigh", "North Carolina"],
	["Tallahassee", "Florida"],
	["Bismarck", "North Dakota"],
	["Atlanta", "Georgia"],
	["Columbus", "Ohio"],
	["Honolulu", "Hawaii"],
	["Oklahoma City", "Oklahoma"],
	["Boise", "Idaho"],
	["Salem", "Oregon"],
	["Springfield", "Illinois"],
	["Harrisburg", "Pennsylvania"],
	["Indianapolis","Indiana"],
	["Providence", "Rhode Island"],
	["Des Moines", "Iowa"],
	["Columbia", "South Carolina"],
	["Topeka", "Kansas"],
	["Pierre", "South Dakota"],
	["Frankfort", "Kentucky"],
	["Nashville", "Tennessee"],
	["Baton Rouge","Louisiana"],
	["Austin", "Texas"],
	["Augusta","Maine"],
	["Salt Lake City", "Utah"],
	["Annapolis", "Maryland"],
	["Montpelier", "Vermont"],
	["Boston", "Massachusetts"],
	["Richmond", "Virginia"],
	["Lansing", "Michigan"],
	["Olympia", "Washington"],
	["Saint Paul", "Minnesota"],
	["Charleston", "West Virginia"],
	["Jackson", "Mississippi"],
	["Madison", "Wisconsin"],
	["Jefferson City", "Missouri"],
	["Cheyenne", "Wyoming"],
	["Concord", "New Hampshire"],
	["Carson City", "Nevada"],
	["Lincoln", "Nebraska"],
	["Helena", "Montana"]
]

globalNumPairs = 0

generateUniqueIndexes = (numPairs) ->
  globalNumPairs = numPairs
  uniqueIndexList = []
  while uniqueIndexList.length < numPairs
    index = Math.floor(Math.random() * 50)
    found = false
    for uniqueIndex in uniqueIndexList
      if uniqueIndex is index then found=true; break
    if not found
      uniqueIndexList.push index
  populateStateAndCityArrays(uniqueIndexList)
  return

populateStateAndCityArrays = (uniqueIndexList) ->
  states = []
  cities = []
  for index in uniqueIndexList
    states.push [capitalsToStates[index][1],index]
    cities.push [capitalsToStates[index][0], index]
  scrambleStateAndCityArrays(states, cities)
  return

scrambleStateAndCityArrays = (states, cities) ->
  i = states.length - 1
  while i > 0
    j = Math.floor(Math.random() * (i + 1))
    temp = states[i]
    states[i] = states[j]
    states[j] = temp
    i--

  i = cities.length - 1
  while i > 0
    j = Math.floor(Math.random() * (i + 1))
    temp = cities[i]
    cities[i] = cities[j]
    cities[j] = temp
    i--
  generateAndAppendHTML(states, cities)
  return

generateAndAppendHTML = (states, cities) ->
  stateHTML = "<div class='row'>"
  cityHTML = "<div class='row'>"
  for state in states
    stateHTML += "<div id=" + state[1] + " class='col-xs-6 col-md-2 states-thumbnails'><p class='thumbnail text-center'>" + state[0] + "</p></div>"
  for city in cities
    cityHTML += "<div id =" + city[1] + " draggable='true' class='col-xs-6 col-md-2 cities-thumbnails'><p class='thumbnail text-center'>" + city[0] + "</p></div>"
  stateHTML += "</div>"
  cityHTML += "</div>"
  $("#states").html(stateHTML)
  $("#cities").html(cityHTML)
  return

globalSeconds = 1

timer = null

startTimer = () ->
  if timer isnt null
    return
  timer = setInterval () ->
    h = Math.floor(globalSeconds / 3600);
    m = Math.floor((globalSeconds - (h * 3600)) / 60);
    s = globalSeconds - (h * 3600) - (m * 60);

    if h < 10 then h = "0"+h
    if m < 10 then m = "0"+m
    if s < 10 then s = "0"+s

    time = h + ":" + m + ":" + s
    $("#time").text(time)
    globalSeconds++
    return
  ,1000
  return

stopTimer = () ->
  clearInterval(timer)
  timer = null
  return

resetTimer = () ->
  stopTimer()
  $("#time").text("00:00:00")
  globalSeconds = 1
  return

jQuery ->

  $("#go").click ->
    startTimer()
    return

  $("#set").click ->
    inputNum = $("#numStates").val()
    numStates = parseInt(inputNum,10)
    if isNaN(numStates)
      $("#alert").modal("show")
      return
    else
      resetTimer()
      generateUniqueIndexes(numStates)
      return

  matched = false
  generateUniqueIndexes(14)

  $("#cities")
    .on('dragstart', ".cities-thumbnails", (e) ->

      startTimer()
      index = $(this).attr("id")
      city = $(this).text();
      id = city + "," + index
      e.originalEvent.dataTransfer.setData("id", id)
      return
    )
    .on("dragend", ".cities-thumbnails", (e) ->
      if matched == true
        $(this).remove()
        matched = false
        if $(".cities-thumbnails").length is 0
          stopTimer()
          time = $("#time").text()
          min = time.substr(2, 4).substr(1,2)
          sec = time.substr(-2, 10)
          $("#successMessage").text("You finished " + globalNumPairs + " states in " + min + " minutes and " + sec + " seconds")
          $("#success").modal("show")

          return
    )

  $("#states")
    .on('dragover', ".states-thumbnails", (e) ->
      e.preventDefault()
      return
    )
    .on("drop", ".states-thumbnails", (e) ->
      id = e.originalEvent.dataTransfer.getData("id")
      idArray = id.split ","
      stateName = $(this).children("p")
      if $(this).attr("id") == idArray[1]
        matchedText = idArray[0] + ", " + stateName.text()
        stateName.text(matchedText)
        matchCSS(stateName)
      else
        $(this).effect("shake");
      return
    )

  matchCSS = (stateName) ->
    stateName.css('background-color', '#90ee90')
    stateName.css('font-size', '17px')
    stateName.css('padding-top', '13px')
    stateName.css('padding-bottom', '13px')
    matched = true





