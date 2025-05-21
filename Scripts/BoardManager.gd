class_name BoardManager

extends Node2D
@export var way_points: WayPointsManager
@export var piecesManager: PiecesManager
@export var animation_PlayerForPlaces: AnimationPlayer

var question_correct
var currentPlayerTurnIndex:int = -1
var currentDiceValue:int = -1
var currentAnimationPlaceName:String = ""
var hasKill:bool = false
var currentPlayerColor:GameManager.PlayerColor

signal OnHasKill

func _ready() -> void:
	UpdatePlayerTurn()
	GameManager.OnPlayerSelectPiece.connect(_on_player_select_piece)
	pass

func _on_player_select_piece(value:Piece) ->void:
	print("on player select piece__",value.get_parent().name)

	var playerType = value.CurrentPlayerColor
	var isPlayerTurn = IsThisPlayerTurn(playerType)
	
	#check is right player turn
	if(isPlayerTurn):
		#stop piece animation after player click on it
		StopPieceAnimation()
		
		MovePieces(currentDiceValue,value)	
		pass
	else: 
		push_error("is player turn is false!!!!!!",isPlayerTurn)
		pass
	pass
	
func IsThisPlayerTurn(playerType:GameManager.PlayerColor)->bool:
	var returnValue:bool = false
	
	match playerType:
		GameManager.PlayerColor.Green:
			returnValue = (currentPlayerTurnIndex == 0)
			pass
		GameManager.PlayerColor.Yellow:
			returnValue = (currentPlayerTurnIndex == 1)
			pass
		GameManager.PlayerColor.Blue:
			returnValue = (currentPlayerTurnIndex == 2)
			pass
		GameManager.PlayerColor.Red:
			returnValue = (currentPlayerTurnIndex == 3)
			pass
	
	return returnValue

func _on_dice_root_on_dice_roll_begin() -> void:
	
	#stop animation because player clicked on dice to start dice animation
	animation_PlayerForPlaces.stop()
	pass # Replace with function body.

func _on_dice_root_on_dice_rolled(value: int) -> void:
	print("diceRolled! Value is ",value)
	currentDiceValue = value
	
	
	await show_popup()
	question_correct = GameManager.valor_da_resposta
	#AQUI QUE TEMOS QUE MEXER
	#if this user get 1 to 5 and this user do not have any piece unlocked to move so skip turn
	if(question_correct==false):
		
		print("resposta ", question_correct)
		
		print("skip this player turn because this player has not unlocked any piece yet")
		#update turn
		UpdatePlayerTurn()
		
		# change gamecurrent state to player select piece
		GameManager.UpdateGameCurrentState(GameManager.GameStateEnum.PlayerCanRollDice)
		
		print("Game state ",GameManager.GameCurrentState)
		return

	#play piece animation because player rolled dice
	PlayPieceAnimation()
	pass # Replace with function body.
	
func MovePieces(value: int, moveThisPiece: Piece) -> void:
	print("move piece: ",value)
	
	#store update value based on current position otherwise piece start moving from 0 each time.
	value+=moveThisPiece.GetCurrentPosition()
	print("after value increase ",value)
	if value>=57:
		value = 57
		pass #fim de jogo
		
	print("after after value increase ",value)
	#update game state other wise use can click on piece or dice and game will brack
	GameManager.UpdateGameCurrentState(GameManager.GameStateEnum.Null)
	
	#move piece step by step 1 second for 1 step
	for i in range(moveThisPiece.GetCurrentPosition(),value):
		print(i)
		moveThisPiece.position = way_points.GetPositionOfThisPoint(i,moveThisPiece.CurrentPlayerColor)
		await get_tree().create_timer(0.1).timeout
	
	if value == 57:
		#update current piece value to current position so next time we get frash value which we use in value
		moveThisPiece.SetCurrentPositionAndCheckKill(56)
		pass
	else:
		#update current piece value to current position so next time we get frash value which we use in value
		moveThisPiece.SetCurrentPositionAndCheckKill(value)
		pass
	
	if (hasKill):
		await OnHasKill
		
	moveThisPiece.CurrentState = GameManager.PieceStateEnum.InWayPoint
	
	#update state so next player can roll dice
	
	GameManager.UpdateGameCurrentState(GameManager.GameStateEnum.PlayerCanRollDice)

	#update turn
	UpdatePlayerTurn()
	pass



func MovePiecesToHome(value: int, moveThisPiece: Piece) -> void:

	#move piece step by step 1 second for 1 step
	for i in range(moveThisPiece.GetCurrentPosition()-1,value-1,-1):
		print("back move ",i,"__",moveThisPiece.CurrentPlayerColor)
		moveThisPiece.position = way_points.GetPositionOfThisPoint(i,moveThisPiece.CurrentPlayerColor)
		await get_tree().create_timer(0.1).timeout
		
	#update current piece value to current position so next time we get frash value which we use in value
	moveThisPiece.CurrentPosition = value
	moveThisPiece.CurrentState = GameManager.PieceStateEnum.InWayPoint
	
	OnHasKill.emit()
	
	pass


func UpdatePlayerTurn() -> void:
	print("Update player turn......")
	currentPlayerTurnIndex+=1
	
	#if player index increase to 4 reset counter again.
	if(currentPlayerTurnIndex >=4):
		currentPlayerTurnIndex=0
		pass

	match currentPlayerTurnIndex:
		0:
			currentPlayerColor = GameManager.PlayerColor.Green
			pass
		1:
			currentPlayerColor = GameManager.PlayerColor.Yellow
			pass
		2:
			currentPlayerColor = GameManager.PlayerColor.Blue
			pass
		3:
			currentPlayerColor = GameManager.PlayerColor.Red
			pass
	
	print("color is ",currentPlayerColor)
	
	if piecesManager.IsGameOver():
		print("is game over!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		return
	
	var pieceGroup = piecesManager.GetPieceGroupBasedOnType(currentPlayerColor)
	
	if pieceGroup!=null && pieceGroup.HasThisPlayerCompleted() == true:
		print("update player turn again because ",currentPlayerColor," has completed game")
		UpdatePlayerTurn()
		return
		
	#play place animation to suggest use it's your turn to roll dice
	PlayPlaceAnimation()
	pass

func PlayPlaceAnimation()-> void:
	
	#update animation state for play right player turn place animation
	match(currentPlayerTurnIndex):
		0:
			currentAnimationPlaceName = "GreenPlaceAnimation"
			pass
		1:
			currentAnimationPlaceName = "YellowPlaceAnimation"
			pass
		2: 
			currentAnimationPlaceName = "BluePlaceAnimation"
			pass
		3:
			currentAnimationPlaceName = "RedPlaceAnimation"
			pass
			
	animation_PlayerForPlaces.stop()
	animation_PlayerForPlaces.play(currentAnimationPlaceName)
	pass

func PlayPieceAnimation()-> void:
	piecesManager.PlayAnimationByPlayerIndex(currentPlayerColor)
	pass

func StopPieceAnimation()-> void:
	piecesManager.StopAnimation()
	pass

func DetectKill(pieceToBeGoHome:Piece)->void:

	if(pieceToBeGoHome == null):
		hasKill = false
	else:
		print("sent ",pieceToBeGoHome.name," to home")
		hasKill = true	
		#MovePiecesToHome(pieceToBeGoHome.StartingPosition,pieceToBeGoHome)
		MovePiecesToHome(0,pieceToBeGoHome)
	pass

var popup_scene = preload("res://QuizAlt/Popup.tscn")

func show_popup():
	# Destrói qualquer popup existente e cria um novo
	if has_node("PopupInstance"):
		$PopupInstance.queue_free()
	
	var new_popup = popup_scene.instantiate()
	add_child(new_popup)
	new_popup.name = "PopupInstance"
	new_popup.popup_centered()  # Ou show() para Window
	await new_popup.tree_exited
	return
