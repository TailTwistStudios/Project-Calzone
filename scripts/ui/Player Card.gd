extends ColorRect

class_name UIPlayerCard

@onready var profilePicture: TextureRect = $"MarginContainer/Player Card/Player Profile Picture"
@onready var playerNameLabel: Label = $"MarginContainer/Player Card/Player Name"

func setPlayerInfo(playerInfo : PlayerInfo):
	color = playerInfo.preferedColor
	profilePicture.texture = playerInfo.profilePicture
	playerNameLabel.text = playerInfo.playerName
