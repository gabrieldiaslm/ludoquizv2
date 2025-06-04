extends Node

enum GameStateEnum {Null,PlayerCanRollDice,PlayerSelectPiece,GameOver}
enum PieceStateEnum {InLobby,InWayPoint,InHouse}
enum PlayerColor {Green,Yellow,Blue,Red}

var temas_variados = preload("res://QuizAlt/Resources/Varied/theme_varied.tres")
var temas_bio = preload("res://QuizAlt/Resources/Biologia/theme_bio.tres")
var temas_historia= preload("res://QuizAlt/Resources/Historia/theme_history.tres")

var theme = temas_historia

var GameCurrentState = GameStateEnum.PlayerCanRollDice
var valor_da_resposta = null

signal OnGameCurrentStateChange(updatedGameState:GameStateEnum)
signal OnPlayerSelectPiece(value:Piece) #this is in use please do not remove it.

func UpdateGameCurrentState(updateGameCurrentState:GameStateEnum):
	GameCurrentState = updateGameCurrentState
	OnGameCurrentStateChange.emit(GameCurrentState)
	pass
