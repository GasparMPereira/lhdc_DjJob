--Gaspar Pereira - gaspar#0880--
Config = {}
Config.DrawDistance = 100.0
Config.UsePeds = true
Config.Locale = 'en'
Config.Jobs = {}
Config.Jobs.clubdj = {
	BlipInfos = {
		Sprite = 614,
		Color = 48
	},
	Zones = {
		CloakRoom = {
			Pos   = {x = -1389.34, y = -591.79, z = 29.35},
			Size  = {x = 2.0, y = 2.0, z = 1.0},
			Color = {r = 0, g = 255, b = 0},
			Marker= 27,
			Blip  = false,
			Name  = _U('dj_club_locker'),
			Type  = "cloakroom",
			Hint  = _U('cloak_change')
		},
		PlayMusic = {
			Pos   = {x = -1381.09, y = -616.22, z = 30.6},
			Size  = {x = 2.0, y = 2.0, z = 1.0},
			Color = {r = 0, g = 0, b = 255},
			Marker= 27,
			Blip  = true,
			Name  = _U('dj_club_locker'),
			Type  = "work",
			Item = {
				{
					name = _U("dj_tip"),
					db_name = "dj_tip",
					time = 60000,
					max = 1000,
					add = 1,
					remove = 0,
					requires = "nothing",
					requires_name = "Nothing",
					drop = 1000
				}
			},
			Hint  = _U('dj_play_music')
		},	
		troca_tips = {
			Pos = {x = -1386.94, y = -589.26, z = 29.35},
			Color = {r = 255, g = 0, b = 0},
			Size = {x = 2.0, y = 2.0, z = 1.0},
			Marker = 27,
			Blip = false,
			Name = _U("delivery_point"),
			Type = "troca_tips",
			Spawner = 1,
			Item = {
				{
					name = _U("delivery"),
					time = 500,
					remove = 1,
					max = 1000,
					price = 350,
					requires = "dj_tip",
					requires_name = _U("dj_tip"),
					drop = 1000
				}
			},
			Hint = _U("dj_cash_tips")
		}
	}
}
Config.InsidePeds = {
    ["Bar1"] = {false, 25, "s_f_y_clubbar_01", vec(-1390.2668457031, -607.52941894531, 30.319568634033, 134.76708984375)},
    ["Bar2"] = {false, 25, "s_m_y_clubbar_01", vec(-1392.4210205078, -603.84124755859, 30.319568634033, 108.83788299561)},
    ["Dancer1"] = {false, 25, "u_f_y_dancerave_01", vec(-1379.9256591797, -617.52117919922, 31.757856369019, 121.92925262451)},
    ["Dancer2"] = {false, 25, "u_f_y_dancerave_01", vec(-1383.4853515625, -612.20495605469, 31.757839202881, 128.48735046387)},
}
Config.PedComponents = {
	["Bar1"] = {false, 0, 0, 0, 0},
	["Bar1"] = {false, 2, 0, 0, 0},
	["Bar1"] = {false, 3, 0, 0, 0},
	["Bar1"] = {false, 4, 0, 0, 0},
	["Bar1"] = {false, 8, 0, 0, 0},
	["Bar2"] = {false, 0, 2, 0, 0},
	["Bar2"] = {false, 2, 2, 0, 0},
	["Bar2"] = {false, 3, 2, 0, 0},
	["Bar2"] = {false, 4, 1, 0, 0},
	["Bar2"] = {false, 8, 0, 0, 0},
	["Bar3"] = {false, 0, 4, 0, 0},
	["Bar3"] = {false, 2, 4, 0, 0},
	["Bar3"] = {false, 3, 4, 0, 0},
	["Bar3"] = {false, 4, 0, 0, 0},
	["Bar3"] = {false, 8, 1, 0, 0}
}
Config.PedAnims = {
	["Bar1"] = {false, "mini@strip_club@drink@idle_a", "idle_a_bartender"},
	["Bar2"] = {false, "mini@strip_club@drink@idle_a", "idle_a_bartender"},
	["Dancer1"] = {false, "anim@amb@nightclub@dancers@podium_dancers@", "hi_dance_facedj_17_v2_female^2"},
	["Dancer2"] = {false, "anim@amb@nightclub@dancers@podium_dancers@", "hi_dance_facedj_17_v2_male^5"}
}
