extends Node

class_name GameboardContainer

var r: int
var c: int

var contents: Array[GameboardComponent]

func add(component: GameboardComponent):
	contents.append(component)
