/*
	These are simple defaults for your project.
 */

world
	fps = 25		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default

	view = 35			// show up to 6 tiles outward from center (13x13 view)
turf
	sand
		icon = 'sand.dmi'
	tatooinehouse1
		icon = 'Suna_H.dmi'
	tatooinehouse2
		icon = 'Suna house 2.dmi'
	tatooinehouse3
		icon = 'Epic house 1.dmi'
	dense
		density = 1
	sandwall
		icon = 'TatooineBuilding1.dmi'
		density = 1
	sandroof
		icon = 'Tatooineroof.dmi'
		density = 1
		opacity = 1
	tatooinehouse4
		icon = 'Tatooinebuilding2.dmi'


// Make objects move 8 pixels per tick when walking

client

	Move()
		. =  ..()
		if(target)
			targetInView()

	Move(atom/loc,dir)

		return mob.canMove(loc,dir)&&..()

	var/atom/movable/target

	Click(obj/newTarget as mob in world)
		if(!istype(newTarget, /atom/movable))
			target = null
			return ..()
		target = newTarget
		usr << output("You are now targeting [target.name]", "OOC")
	proc
		targetInView()
			if(!(target in view(mob)))
				target = null


mob
	step_size = 32

	Logout()
		..()
		var/savefile/F = new(ckey)
		Write(F)
		del(src)
	Write(savefile/F)
		saved_x = x
		saved_y = y
		saved_z = z
		F["verbs"] << src.verbs
		..()

	Read(savefile/F)
		..()
		Move(locate(saved_x,saved_y,saved_z))
		src.verbs += F["verbs"]

	Login()
		winset(usr, "MainWindow", "is-maximized = true")
		switch(alert(usr, "Welcome", , "Load", "Create"))
			if("Create")
				usr.Create()
			if("Load")
				var/savefile/F = new(ckey)
				Read(F)
				return ..()

	var
		savefile/SaveFile = new("players.sav")

		saved_x
		saved_y
		saved_z

		HP = 100
		MaxHP = 100
		Stamina = 100
		MaxStam = 100
		Strength = 1
		Reflex = 1
		Durability = 1
		AttackSpeed = 1
		Accuracy = 1
		Force = 1

		StamGain = 0
		StrengthGain = 0
		ReflexGain = 0
		DuraGain = 0
		ASGain = 0
		AccGain = 0
		ForceGain = 0

		StamMod = 1
		StrMod = 1
		RfxMod = 1
		DuraMod = 1
		ASMod = 1
		AccMod = 1
		FrcMod = 1
		ModAlloc = 10


		Parryable = 0
		Parried = 0

		Clashable = 0
		Clashed = 0
		ClashStrength = 0

		KnockedOut = 0

		Blocking = 0
		BlockMeter = 4
		Meditating = 0

		SaberEquipped = 0

		Base
		Gender
		SkinColor
		Class

		ForceSensitive

		Hair

		TextColor

		Credit

		OOCEnabled

		Pushpull = 1

		Frozen

		save

	verb
		Create()
			set hidden = 1

			if(save == 1)
				switch(alert(usr, "You already have a save, would you still like to create a new character? This cannot be reverse!",,"Yes", "No"))
					if("Yes")
						save = 0
					if("No")
						return
			HP = 100
			MaxHP = 100
			Stamina = 100
			MaxStam = 100
			Strength = 1
			Reflex = 1
			Durability = 1
			AttackSpeed = 1
			Accuracy = 1
			Force = 1

			StamGain = 0
			StrengthGain = 0
			ReflexGain = 0
			DuraGain = 0
			ASGain = 0
			AccGain = 0
			ForceGain = 0

			StamMod = 1
			StrMod = 1
			RfxMod = 1
			DuraMod = 1
			ASMod = 1
			AccMod = 1
			FrcMod = 1
			ModAlloc = 10


			Parryable = 0
			Parried = 0

			Clashable = 0
			Clashed = 0
			ClashStrength = 0

			KnockedOut = 0

			Blocking = 0
			BlockMeter = 4
			Meditating = 0

			SaberEquipped = 0

			Pushpull = 1

			var/class = input("What class would you like to be?") in list("Jedi", "Rebel", "Sith", "Bounty Hunters")
			var/G = input("What gender would you like to be?") in list("Male", "Female")
			var/S = input("What skin color would you like to pick?") in list("White","Tan","Black")
			var/list/Hairs=list("Bald"='denseobject.dmi', "Bowl"='Bowl.dmi',"Chiyo"='Chiyo.dmi',"Choji"='Choji.dmi',"Afro"='Afro.dmi',"Crazy Afro"='Crazy Afro.dmi',"Crazy"='Crazy.dmi',"Emo"='Emo.dmi',"Hinata"='Hinata.dmi',"Juugo"='Juugo.dmi',"Kakashi"='Kakashi.dmi',"Kisame"='Kisame.dmi',"Layered"='Layered.dmi',"Little"='Little.dmi',"Long"='Long.dmi',"Loose Ponytail"='Loose Ponytail.dmi',"Mohawk"='Mohawk.dmi',"Naruto"='Naruto.dmi',"Ponytail"='Ponytail.dmi',"Sakura"='Sakura.dmi',"Sasuke"='Sasuke.dmi',"Short"='Short.dmi',"Spikey"='Spikey.dmi',"Spikey2"='Spikey2.dmi',"Spikey3"='Spikey3.dmi',"Tenten"='Tenten.dmi',"Topknot"='Topknot.dmi',"Untidy"='Untidy.dmi',"Villager"='Villager.dmi',"Wild"='Wild.dmi',"Jiraiya"='Jiraiya.dmi')
			var/hairChoice = input("Which hair","hair type") in Hairs
			var/color=input("Please select a color.") as color
			var/hairer = Hairs[hairChoice]
			var/igname = input("Name?") as text

			if(length(igname) <= 1)
				src << "Please choose a longer name."
				return
			if(length(igname) >= 32)
				src << "Please choose a shorter name."
				return

			var/body = input("What body size do you want?") in list("Small", "Medium", "Large")

			var/alloc1 = input("You have 10 points to allocate, which stat modifier would you like to increase?") in list("Stamina", "Strength", "Reflex", "Durability", "Attack Speed", "Accuracy", "Force")
			if(alloc1 == "Stamina")
				StamMod += 0.5
			if(alloc1 == "Strength")
				StrMod += 0.5
			if(alloc1 == "Reflex")
				RfxMod += 0.5
			if(alloc1 == "Durability")
				DuraMod += 0.5
			if(alloc1 == "Attack Speed")
				ASMod += 0.5
			if(alloc1 == "Accuracy")
				AccMod += 0.5
			if(alloc1 == "Force")
				FrcMod += 0.5

			var/alloc2 = input("You have 9 points to allocate, which stat modifier would you like to increase?") in list("Stamina", "Strength", "Reflex", "Durability", "Attack Speed", "Accuracy", "Force")
			if(alloc2 == "Stamina")
				StamMod += 0.5
			if(alloc2 == "Strength")
				StrMod += 0.5
			if(alloc2 == "Reflex")
				RfxMod += 0.5
			if(alloc2 == "Durability")
				DuraMod += 0.5
			if(alloc2 == "Attack Speed")
				ASMod += 0.5
			if(alloc2 == "Accuracy")
				AccMod += 0.5
			if(alloc2 == "Force")
				FrcMod += 0.5

			var/alloc3 = input("You have 8 points to allocate, which stat modifier would you like to increase?") in list("Stamina", "Strength", "Reflex", "Durability", "Attack Speed", "Accuracy", "Force")
			if(alloc3 == "Stamina")
				StamMod += 0.5
			if(alloc3 == "Strength")
				StrMod += 0.5
			if(alloc3 == "Reflex")
				RfxMod += 0.5
			if(alloc3 == "Durability")
				DuraMod += 0.5
			if(alloc3 == "Attack Speed")
				ASMod += 0.5
			if(alloc3 == "Accuracy")
				AccMod += 0.5
			if(alloc3 == "Force")
				FrcMod += 0.5

			var/alloc4 = input("You have 7 points to allocate, which stat modifier would you like to increase?") in list("Stamina", "Strength", "Reflex", "Durability", "Attack Speed", "Accuracy", "Force")
			if(alloc4 == "Stamina")
				StamMod += 0.5
			if(alloc4 == "Strength")
				StrMod += 0.5
			if(alloc4 == "Reflex")
				RfxMod += 0.5
			if(alloc4 == "Durability")
				DuraMod += 0.5
			if(alloc4 == "Attack Speed")
				ASMod += 0.5
			if(alloc4 == "Accuracy")
				AccMod += 0.5
			if(alloc4 == "Force")
				FrcMod += 0.5

			var/alloc5 = input("You have 6 points to allocate, which stat modifier would you like to increase?") in list("Stamina", "Strength", "Reflex", "Durability", "Attack Speed", "Accuracy", "Force")
			if(alloc5 == "Stamina")
				StamMod += 0.5
			if(alloc5 == "Strength")
				StrMod += 0.5
			if(alloc5 == "Reflex")
				RfxMod += 0.5
			if(alloc5 == "Durability")
				DuraMod += 0.5
			if(alloc5 == "Attack Speed")
				ASMod += 0.5
			if(alloc5 == "Accuracy")
				AccMod += 0.5
			if(alloc5 == "Force")
				FrcMod += 0.5

			var/alloc6 = input("You have 5 points to allocate, which stat modifier would you like to increase?") in list("Stamina", "Strength", "Reflex", "Durability", "Attack Speed", "Accuracy", "Force")
			if(alloc6 == "Stamina")
				StamMod += 0.5
			if(alloc6 == "Strength")
				StrMod += 0.5
			if(alloc6 == "Reflex")
				RfxMod += 0.5
			if(alloc6 == "Durability")
				DuraMod += 0.5
			if(alloc6 == "Attack Speed")
				ASMod += 0.5
			if(alloc6 == "Accuracy")
				AccMod += 0.5
			if(alloc6 == "Force")
				FrcMod += 0.5

			var/alloc7 = input("You have 4 points to allocate, which stat modifier would you like to increase?") in list("Stamina", "Strength", "Reflex", "Durability", "Attack Speed", "Accuracy", "Force")
			if(alloc7 == "Stamina")
				StamMod += 0.5
			if(alloc7 == "Strength")
				StrMod += 0.5
			if(alloc7 == "Reflex")
				RfxMod += 0.5
			if(alloc7 == "Durability")
				DuraMod += 0.5
			if(alloc7 == "Attack Speed")
				ASMod += 0.5
			if(alloc7 == "Accuracy")
				AccMod += 0.5
			if(alloc7 == "Force")
				FrcMod += 0.5

			var/alloc8 = input("You have 3 points to allocate, which stat modifier would you like to increase?") in list("Stamina", "Strength", "Reflex", "Durability", "Attack Speed", "Accuracy", "Force")
			if(alloc8 == "Stamina")
				StamMod += 0.5
			if(alloc8 == "Strength")
				StrMod += 0.5
			if(alloc8 == "Reflex")
				RfxMod += 0.5
			if(alloc8 == "Durability")
				DuraMod += 0.5
			if(alloc8 == "Attack Speed")
				ASMod += 0.5
			if(alloc8 == "Accuracy")
				AccMod += 0.5
			if(alloc8 == "Force")
				FrcMod += 0.5

			var/alloc9 = input("You have 2 points to allocate, which stat modifier would you like to increase?") in list("Stamina", "Strength", "Reflex", "Durability", "Attack Speed", "Accuracy", "Force")
			if(alloc9 == "Stamina")
				StamMod += 0.5
			if(alloc9 == "Strength")
				StrMod += 0.5
			if(alloc9 == "Reflex")
				RfxMod += 0.5
			if(alloc9 == "Durability")
				DuraMod += 0.5
			if(alloc9 == "Attack Speed")
				ASMod += 0.5
			if(alloc9 == "Accuracy")
				AccMod += 0.5
			if(alloc9 == "Force")
				FrcMod += 0.5

			var/alloc10 = input("You have 1 points to allocate, which stat modifier would you like to increase?") in list("Stamina", "Strength", "Reflex", "Durability", "Attack Speed", "Accuracy", "Force")
			if(alloc10 == "Stamina")
				StamMod += 0.5
			if(alloc10 == "Strength")
				StrMod += 0.5
			if(alloc10 == "Reflex")
				RfxMod += 0.5
			if(alloc10 == "Durability")
				DuraMod += 0.5
			if(alloc10 == "Attack Speed")
				ASMod += 0.5
			if(alloc10 == "Accuracy")
				AccMod += 0.5
			if(alloc10 == "Force")
				FrcMod += 0.5

			if(body == "Small")
				usr.RfxMod += 0.5
				usr.ASMod += 0.5
				usr.StrMod -= 0.5
				usr.DuraMod -= 0.5
			if(body == "Medium")
				usr.RfxMod += 0.25
				usr.ASMod += 0.25
				usr.DuraMod += 0.25
				usr.StrMod += 0.25
			if(body == "Large")
				usr.RfxMod -= 0.5
				usr.ASMod -= 0.5
				usr.StrMod += 0.5
				usr.DuraMod += 0.5

			usr.name = igname
			usr.Gender = G
			usr.SkinColor = S
			usr.Class = class

			if(usr.Gender == "Male")
				if(usr.SkinColor == "White")
					icon = 'Base_Pale.dmi'
					Base = 1

				else if(usr.SkinColor == "Tan")
					icon = 'Base_Tan.dmi'
					Base = 2

				else if(usr.SkinColor == "Black")
					icon = 'Base_Black.dmi'
					Base = 3

			else if(usr.Gender == "Female")
				if(usr.SkinColor == "White")
					icon = 'Base_FemalePale.dmi'
					Base = 4

				else if(usr.SkinColor == "Tan")
					icon = 'Base_FemaleTan.dmi'
					Base = 5

				else if(usr.SkinColor == "Black")
					icon = 'Base_FemaleBlack.dmi'
					Base = 6
			hairer += color
			usr.Hair = hairer
			usr.overlays += usr.Hair

			if(class == "Jedi")
				new/obj/Lightsaber(usr)
				usr.ForceSensitive = 1
				new/mob/Force/verb/Force_PushPull(usr)
				new/mob/Force/verb/Force_Freeze(usr)
			if(class == "Sith")
				new/obj/LightsaberRed(usr)
				usr.ForceSensitive = 1
				new/mob/Force/verb/Force_Choke(usr)
				new/mob/Force/verb/Force_PushPull(usr)
			if(class == "Bounty Hunter" || class == "Rebel")
				var/fchance = rand(1,100)
				if(fchance == 1)
					usr.ForceSensitive = 1
				new/obj/Blaster(usr)
				new/obj/Bowcaster(usr)
				new/obj/Blaster_Rifle(usr)
				new/mob/Rebel/verb/Push(usr)
				new/obj/Wrist_Rocket_Launcher(usr)
				new/obj/Thermal_Detonator(usr)
			usr.loc = locate(1, 1, 1)
			usr.TextColor = "#84f0ec"
			usr.Credit = 1000
			OOCPlayers += usr

			usr.OOCEnabled = 1

		Toggle_OOC()
			set category = "Other"
			if(!(usr in OOCPlayers))
				OOCPlayers+=src

				OOCEnabled = 1

				src << output("You have enabled OOC!", "OOC")
			else
				OOCPlayers-=src

				OOCEnabled = 0

				src << output("You have disabled OOC!", "OOC")

		Attack() //Regular attack
			set category = "Combat"
			if(usr.Frozen == 1 || usr.HP <= 0 || usr.KnockedOut == 1 || usr.Meditating == 1 || usr.Stamina <= 0)
				return
			if(usr.Clashed == 1)
				usr.ClashStrength += 1
				return
			flick("Attack", usr)
			for(var/mob/M in get_step(src,src.dir))
				usr.Stamina -= 10
				usr.Parryable = 1
				sleep(2)
				if(usr.Parried == 1)
					usr.Frozen = 1
					usr.Parried = 0
					usr.Parryable = 0
					sleep(10)
					usr.Frozen = 0
					return
				else
					usr.Parryable = 0
					var/Damage=max(0,src.Strength-M.Durability)
					M.TakeDamage(Damage, src)
				usr.StamGain += 10

		Heavy_Attack() //Heavy attack the breaks guard
			set category = "Combat"
			if(usr.Frozen == 1 || usr.HP <= 0 || usr.KnockedOut == 1 || usr.Meditating == 1 || usr.Stamina <= 0 || usr.Clashed == 1)
				return
			flick("HeavyAttack", usr)
			for(var/mob/M in get_step(src,src.dir))
				usr.Stamina -= 10
				usr.Parryable = 1
				usr.Clashable = 1
				if(M.Clashable == 1)
					M.Clashed = 1
					usr.Clashed = 1
					var/strength = src.Strength
					M.Clashing(strength, src)
				sleep(5)
				if(usr.Clashed == 1)
					return
				if(usr.Parried == 1)
					usr.Frozen = 1
					usr.Parried = 0
					usr.Parryable = 0
					sleep(10)
					usr.Frozen = 0
					return
				else
					usr.Parryable = 0
					var/Damage=max(0,src.Strength-M.Durability)
					M.TakeHeavyDamage(Damage, src)
				usr.StamGain += 10




		Block() //Used to block incoming attacks including blasters, broken by heavy attacks
			set category = "Combat"
			if(usr.Frozen == 1 || usr.HP <= 0 || usr.KnockedOut == 1)
				return
			if(usr.Blocking == 0)
				usr.Blocking = 1
				usr.overlays+= 'Block.dmi'
				return
			if(usr.Blocking == 1)
				usr.Blocking = 0
				usr.overlays-= 'Block.dmi'
				BlockRegen()
				return

		Parry() //Parries attacks when timed correctly
			set category = "Combat"
			flick("Attack", usr)
			usr.Stamina -= 5
			for(var/mob/M in get_step(src, src.dir))
				if(M.Parryable == 1)
					M.Parried = 1
					view() << "[usr] just parried [M]!"
					usr.StamGain += 10
					usr.ReflexGain += 1
				else
					return
		Meditate()
			set category = "Other"
			if(Meditating == 0)
				Meditating = 1
				Frozen = 1
				usr.icon_state = "Focus"
				MedReg()
				sleep(300)
				PostCombatEXP()
				return
			if(Meditating == 1)
				Meditating = 0
				Frozen = 0
				usr.icon_state = null

		Say(say as text)
			set category = "Other"
			if(say == " " || "")
				return
			if(findtext(say,"(") || findtext(say, ")"))
				view() << output("<font color=[TextColor]>[usr.name] OOCly says,</font color> [say]", "OOC")
				return
			view() << "<font color=[TextColor]>[usr.name] says,</font color> [say]"
		Roleplay(rp as message)
			set category = "Other"
			view() << "<font color=[TextColor]>[usr.name] [rp]</font color>"
		Whisper(whisper as text)
			set category = "Other"
			view(3, usr) << "<font color=[TextColor]>[usr.name] whispers,</font color> [whisper]"
		Think(think as text)
			set category = "Other"
			view() << "<font color=[TextColor]>[usr.name] thinks,</font color> [think]"
		Give_Money()
			set category = "Other"
			set src in oview(1)
			var/MoneyAmount = input("How much would you like to give them?") as num

			if(usr.client.address == src.client.address)
				world << output("<center><font color=red>[usr] tried to give their alt money!</font color></center>", "OOC")
				return

			if(MoneyAmount > usr.Credit)
				return

			if(findtext(MoneyAmount,".") && MoneyAmount > 0)
				return

			if(MoneyAmount > 0)
				view() << output("[usr.name] has given [src.name] [MoneyAmount] Yen!", "OOC")
				src.Credit += MoneyAmount
				usr.Credit -= MoneyAmount
			else
				return
		OOC(text as text)
			set category = "Other"
			if(text == " " || "")
				return
			OOCPlayers << output("<font color=[usr.TextColor]>(<font color = white>World</font color>)([usr.key])</font color>:[text]", "OOC")
		Admin_Help(message as message)
			set category = "Other"
			src  << output("(<font color = red>Admin Help</font color>)([usr.key])([usr]): [message]", "OOC")
			admins << output("(<font color = red>Admin Help</font color>)([usr.key])([usr]): [message]", "OOC")

	proc
		Clashing(var/Strength, var/mob/Clasher)
			Clasher.Frozen = 1
			src.Frozen = 1
			src.icon_state = "Attack"
			Clasher.icon_state = "Attack"
			view() << "[Clasher] and [src] begin clashing!"
			src << "Use the Attack verb to increase your strength."
			sleep(100)
			if(src.Strength+src.ClashStrength > Clasher.Strength+Clasher.ClashStrength)
				step(Clasher, src.dir)
				view() << "[src] won the clash!"
				src.Frozen = 0
				src.icon_state = null
				Clasher.Frozen = 0
				Clasher.icon_state = null
				Clasher.ClashStrength = 0
				src.ClashStrength = 0
				return
			if(src.Strength+src.ClashStrength < Clasher.Strength+Clasher.ClashStrength)
				step(src, Clasher.dir)
				view() << "[Clasher] won the clash!"
				src.Frozen = 0
				src.icon_state = null
				Clasher.Frozen = 0
				Clasher.icon_state = null
				Clasher.ClashStrength = 0
				src.ClashStrength = 0
				return

		PostCombatEXP()
			MaxStam += StamGain*StamMod
			Strength += StrengthGain*StrMod
			Reflex += ReflexGain*RfxMod
			Durability += DuraGain*DuraMod
			AttackSpeed += ASGain*ASMod
			Accuracy += AccGain*AccMod
			Force += ForceGain*FrcMod
			ForceGain = 0
			AccGain = 0
			ASGain = 0
			DuraGain = 0
			ReflexGain = 0
			StrengthGain = 0
			StamGain = 0

		TakeDamage(var/Damage, var/mob/Attacker)
			if(src.HP <= 0)
				return
			if(src.Blocking == 0)
				if(src.Reflex-2000 >= Attacker.AttackSpeed && src.Reflex-4000 < Attacker.AttackSpeed)
					var/chance = rand(1, 100)
					if(chance > 0 && chance <= 95)
						flick("Dodge", src)
						src.ReflexGain += 1
						Attacker.ASGain += 1
						return
				if(src.Reflex-1000 >= Attacker.AttackSpeed && src.Reflex-2000 < Attacker.AttackSpeed)
					var/chance = rand (1, 100)
					if(chance > 0 && chance <= 90)
						flick("Dodge",src)
						src.ReflexGain += 1
						Attacker.ASGain += 1
						return
				if(src.Reflex-500 >= Attacker.AttackSpeed && src.Reflex-1000 < Attacker.AttackSpeed)
					var/chance = rand(1, 100)
					if(chance > 0 && chance <= 75)
						flick("Dodge",src)
						src.ReflexGain += 1
						Attacker.ASGain += 1
						return
				if(src.Reflex >= Attacker.AttackSpeed && src.Reflex-500 < Attacker.AttackSpeed)
					var/chance = rand(1, 100)
					if(chance > 0 && chance <=50)
						flick("Dodge",src)
						src.ReflexGain += 1
						Attacker.ASGain += 1
						return
				if(src.Reflex < Attacker.AttackSpeed)
					var/chance = rand(1, 100)
					if(chance > 0 && chance <= 25)
						flick("Dodge",src)
						src.ReflexGain += 1
						Attacker.ASGain += 1
						return
				src.HP-=Damage
				src.DuraGain += 1
				Attacker.StrengthGain += 1
				src.KOCheck(Attacker)
			if(src.Blocking == 1 && src.BlockMeter > 0)
				src.BlockMeter -= 1
				view() << "[src] just blocked [Attacker]'s attack!"
				src.DuraGain+=1
				Attacker.StrengthGain+=1
				return
			if(src.BlockMeter == 0)
				var/BD = Damage/2
				src.HP-=BD
				src.icon_state = null
				view() << "[Attacker] just broke [src]'s guard!"
				src.Blocking = 0
				src.overlays-= 'Block.dmi'
				src.DuraGain += 1
				Attacker.StrengthGain += 1
				src.KOCheck(Attacker)
				src.BlockRegen()

		BlastTakeDamage(var/Damage, var/mob/Attacker)
			if(src.HP <= 0)
				return
			if(src.Blocking == 0)
				if(src.Reflex-2000 >= Attacker.Accuracy && src.Reflex-4000 < Attacker.Accuracy)
					var/chance = rand(1, 100)
					if(chance > 0 && chance <= 95)
						flick("Dodge", src)
						src.ReflexGain += 1
						Attacker.AccGain += 1
						return
				if(src.Reflex-1000 >= Attacker.Accuracy && src.Reflex-2000 < Attacker.Accuracy)
					var/chance = rand (1, 100)
					if(chance > 0 && chance <= 90)
						flick("Dodge",src)
						src.ReflexGain += 1
						Attacker.AccGain += 1
						return
				if(src.Reflex-500 >= Attacker.Accuracy && src.Reflex-1000 < Attacker.Accuracy)
					var/chance = rand(1, 100)
					if(chance > 0 && chance <= 75)
						flick("Dodge",src)
						src.ReflexGain += 1
						Attacker.AccGain += 1
						return
				if(src.Reflex >= Attacker.Accuracy && src.Reflex-500 < Attacker.Accuracy)
					var/chance = rand(1, 100)
					if(chance > 0 && chance <=50)
						flick("Dodge",src)
						src.ReflexGain += 1
						Attacker.AccGain += 1
						return
				if(src.Reflex < Attacker.Accuracy)
					var/chance = rand(1, 100)
					if(chance > 0 && chance <= 25)
						flick("Dodge",src)
						src.ReflexGain += 1
						Attacker.AccGain += 1
						return
				src.HP-=Damage
				src.DuraGain += 1
				Attacker.ForceGain += 1
				src.KOCheck(Attacker)
			if(src.Blocking == 1 && src.BlockMeter > 0)
				src.BlockMeter -= 1
				view() << "[src] just blocked [Attacker]'s attack!"
				src.DuraGain+=1
				Attacker.ForceGain+=1
				return
			if(src.BlockMeter == 0)
				var/BD = Damage/2
				src.HP-=BD
				src.icon_state = null
				view() << "[Attacker] just broke [src]'s guard!"
				src.Blocking = 0
				src.overlays-= 'Block.dmi'
				src.DuraGain += 1
				Attacker.ForceGain += 1
				src.KOCheck(Attacker)
				src.BlockRegen()

		BlastTakeHeavyDamage(var/Damage, var/mob/Attacker)
			if(src.HP <= 0)
				return
			if(src.Blocking == 0)
				if(src.Reflex-2000 >= Attacker.Accuracy*0.75 && src.Reflex-4000 < Attacker.Accuracy*0.75)
					var/chance = rand(1, 100)
					if(chance > 0 && chance <= 95)
						flick("Dodge", src)
						src.ReflexGain += 1
						Attacker.AccGain += 1
						return
				if(src.Reflex-1000 >= Attacker.Accuracy*0.75 && src.Reflex-2000 < Attacker.Accuracy*0.75)
					var/chance = rand (1, 100)
					if(chance > 0 && chance <= 90)
						flick("Dodge",src)
						src.ReflexGain += 1
						Attacker.AccGain += 1
						return
				if(src.Reflex-500 >= Attacker.Accuracy*0.75 && src.Reflex-1000 < Attacker.Accuracy*0.75)
					var/chance = rand(1, 100)
					if(chance > 0 && chance <= 75)
						flick("Dodge",src)
						src.ReflexGain += 1
						Attacker.AccGain += 1
						return
				if(src.Reflex >= Attacker.Accuracy*0.75 && src.Reflex-500 < Attacker.Accuracy*0.75)
					var/chance = rand(1, 100)
					if(chance > 0 && chance <=50)
						flick("Dodge",src)
						src.ReflexGain += 1
						Attacker.AccGain += 1
						return
				if(src.Reflex < Attacker.Accuracy*0.75)
					var/chance = rand(1, 100)
					if(chance > 0 && chance <= 25)
						flick("Dodge",src)
						src.ReflexGain += 1
						Attacker.AccGain += 1
						return
				var/HT = Damage*1.25
				src.HP -= HT
				src.DuraGain += 1
				Attacker.ForceGain += 1
				src.KOCheck(Attacker)
			if(src.Blocking == 1)
				var/HTB = Damage*0.75
				src.HP -= HTB
				view() << "[Attacker] just broke [src]'s guard with a heavy attack!"
				src.Blocking = 0
				src.overlays-= 'Block.dmi'
				src.DuraGain += 1
				Attacker.ForceGain += 1
				src.KOCheck(Attacker)
				src.BlockRegen()

		TakeHeavyDamage(var/Damage, var/mob/Attacker)
			if(src.HP <= 0)
				return
			if(src.Blocking == 0)
				if(src.Reflex-2000 >= Attacker.AttackSpeed*0.75 && src.Reflex-4000 < Attacker.AttackSpeed*0.75)
					var/chance = rand(1, 100)
					if(chance > 0 && chance <= 95)
						flick("Dodge", src)
						src.ReflexGain += 1
						Attacker.ASGain += 1
						return
				if(src.Reflex-1000 >= Attacker.AttackSpeed*0.75 && src.Reflex-2000 < Attacker.AttackSpeed*0.75)
					var/chance = rand (1, 100)
					if(chance > 0 && chance <= 90)
						flick("Dodge",src)
						src.ReflexGain += 1
						Attacker.ASGain += 1
						return
				if(src.Reflex-500 >= Attacker.AttackSpeed*0.75 && src.Reflex-1000 < Attacker.AttackSpeed*0.75)
					var/chance = rand(1, 100)
					if(chance > 0 && chance <= 75)
						flick("Dodge",src)
						src.ReflexGain += 1
						Attacker.ASGain += 1
						return
				if(src.Reflex >= Attacker.AttackSpeed*0.75 && src.Reflex-500 < Attacker.AttackSpeed*0.75)
					var/chance = rand(1, 100)
					if(chance > 0 && chance <=50)
						flick("Dodge",src)
						src.ReflexGain += 1
						Attacker.ASGain += 1
						return
				if(src.Reflex < Attacker.AttackSpeed*0.75)
					var/chance = rand(1, 100)
					if(chance > 0 && chance <= 25)
						flick("Dodge",src)
						src.ReflexGain += 1
						Attacker.ASGain += 1
						return
				var/HT = Damage*1.25
				src.HP -= HT
				src.DuraGain += 1
				Attacker.StrengthGain += 1
				step(src, Attacker.dir)
				var/duration = 2
				spawn(1)
					var/oldeye=src.client.eye
					var/x
					for(x=0;x<duration,x++)
						src.client.eye = get_step(src,pick(NORTH,SOUTH,EAST,WEST))
						sleep(1)
					src.client.eye=oldeye
				src.KOCheck(Attacker)
			if(src.Blocking == 1)
				var/HTB = Damage*0.75
				src.HP -= HTB
				view() << "[Attacker] just broke [src]'s guard with a heavy attack!"
				src.Blocking = 0
				src.overlays-= 'Block.dmi'
				src.DuraGain += 1
				Attacker.StrengthGain += 1
				src.KOCheck(Attacker)
				src.BlockRegen()

		KOCheck(var/mob/Attacker)
			if(src.HP<=0 && src.KnockedOut == 0)
				view() << "[Attacker] knocked [src] out!"
				src.KnockedOut = 1
				src.icon_state = "KO"
				src.Frozen = 1
				sleep(600)
				if(KnockedOut == 0)
					return
				else
					src.KnockedOut = 0
					src.Frozen = 0
					src.icon_state = null
					src.HP = 1
					BlockMeter = 4
			else
				return
		BlockRegen()
			for()
				if(BlockMeter == 4 || Blocking == 1)
					return
				BlockMeter += 1
				sleep(10)
		MedReg()
			var/EXPCD = 0
			for()
				if(Meditating == 0)
					return
				if(EXPCD == 30)
					PostCombatEXP()
				if(HP < MaxHP)
					HP += MaxHP*0.10
				if(Stamina < MaxStam)
					Stamina += MaxStam*0.10
				if(HP > MaxHP)
					HP = MaxHP
				if(Stamina > MaxStam)
					Stamina = MaxStam
				EXPCD += 1
				sleep(10)

		canMove(atom/NewLoc,Dir=0)
			return !Frozen

		Quake_Effect(duration)
			if(!src.client)return
			spawn(1)
				var/oldeye=src.client.eye
				var/x
				for(x=0;x<duration,x++)
					src.client.eye = get_step(src,pick(NORTH,SOUTH,EAST,WEST))
					sleep(1)
				src.client.eye=oldeye
var/mob/OOCPlayers = list()

mob/Stat()
	statpanel("Status")
	stat(usr)
	stat("Health:", "[MaxHP]/[HP]")
	stat("Stamina:", "[MaxStam]/[Stamina]")
	stat("Strength:", "[Strength]")
	stat("Durability:", "[Durability]")
	stat("Attack Speed:", "[AttackSpeed]")
	stat("Reflex:", "[Reflex]")
	stat("Accuracy:", "[Accuracy]")
	stat("Force:", "[Force]")
	stat("Targeting:", "[client.target]")
	statpanel("Inventory")
	stat(contents)


obj/Lightsaber
	icon = 'Lightsaber.dmi'
	var/Equipped = 0

	Click()
		if(src in usr.contents)
			if(Equipped == 0)
				usr.overlays+=src.icon
				Equipped = 1
				suffix = "**Equipped**"
			else
				usr.overlays-=src.icon
				Equipped = 0
				suffix = ""
obj/Wrist_Rocket
	icon = 'Rocket.dmi'

obj/Wrist_Rocket_Launcher
	var/CD = 0
	verb
		Fire_Wrist_Rocket()
			if(CD == 1)
				return
			flick("Attack", usr)
			CD = 1
			var/obj/O = new/obj/Wrist_Rocket(usr.loc)
			O.dir = usr.dir
			var/life = 0
			while(O)
				life += 1
				if(life == 300)
					CD = 0
					del(O)
					return
				step(O, O.dir)
				var/turf/Y = get_step(O, O.dir)
				if(!Y)
					del(O)
					break
				for(var/mob/M in get_step(O, O.dir))
					if(M == usr)
						continue
					var/damage = max(0, usr.Force*1.25-M.Durability)
					M.HP -= damage
					del(O)
				sleep(1)
			for()
				if(CD == 0)
					return
				CD -= 1
				sleep(1)

obj/Thermal_Detonator
	icon = 'ThermalDetonator.dmi'
	var/thrown = 0
	Click()
		if(thrown == 1)
			return
		thrown = 1
		flick("Attack", usr)
		var/obj/O = new/obj/Thermal_Detonator(usr.loc)
		O.icon_state = "Thrown"
		O.dir = usr.dir
		while(O)
			step(O, O.dir)
			var/turf/Y = get_step(O, O.dir)
			if(!Y)  // If the projectile hits the end of the map...
				del(O)
				break
			for(var/mob/M in get_step(O, O.dir))
				if(M == usr)
					continue
				var/damage = max(0, usr.Force*1.25-M.Durability)
				M.HP -= damage
				O.icon_state = "Explosion"
				sleep(8)
				del(O)
			sleep(1)


obj/LightsaberRed
	icon = 'LightsaberRed.dmi'
	var/Equipped = 0

	Click()
		if(src in usr.contents)
			if(Equipped == 0)
				usr.overlays+=src.icon
				Equipped = 1
				suffix = "**Equipped**"
			else
				usr.overlays-=src.icon
				Equipped = 0
				suffix = ""
obj/Bowcaster
	icon = 'Blaster.dmi'
	var/Equipped = 0
	var/Blasts = 6

	Click()
		if(src in usr.contents)
			if(Equipped == 0)
				usr.overlays+=src.icon
				Equipped = 1
				suffix = "**Equipped**"
			else
				usr.overlays-=src.icon
				Equipped = 0
				suffix = ""
	verb
		BlastBow()
			set category = "Combat"
			if(Blasts < 1)
				return
			flick("Attack",usr)
			Blasts -= 3
			usr << "You have [Blasts/3] blasts left."
			var/blastop
			var/blastbottom
			if(usr.dir == 1 || usr.dir == 2)
				blastop = locate(usr.x-1, usr.y, usr.z)
				blastbottom = locate(usr.x+1, usr.y, usr.z)
			if(usr.dir == 4 || usr.dir == 8)
				blastop = locate(usr.x, usr.y-1, usr.z)
				blastbottom = locate(usr.x, usr.y+1, usr.z)
			var/obj/O = new /obj/Beam(blastop)
			var/obj/O2 = new /obj/Beam(usr.loc)
			var/obj/O3 = new /obj/Beam(blastbottom)
			O.icon_state = null
			O.dir = usr.dir
			O2.dir = usr.dir
			O3.dir = usr.dir
			while(O)
				step(O, O.dir)
				var/turf/Y = get_step(O, O.dir)
				if(!Y)  // If the projectile hits the end of the map...
					del(O)
					del(O2)
					del(O3)
					break
				for(var/mob/M in get_step(O, O.dir))
					if(M == usr)
						continue
					var/Damage = max(0, usr.Force*1.25-M.Durability)
					M.TakeDamage(Damage, usr)
					del(O)
				step(O3, O3.dir)
				for(var/mob/M in get_step(O3, O3.dir))
					if(M == usr)
						continue
					var/Damage = max(0, usr.Force*1.25-M.Durability)
					M.TakeDamage(Damage, usr)
					del(O3)
				step(O2, O2.dir)
				for(var/mob/M in get_step(O2, O2.dir))
					if(M == usr)
						continue
					var/Damage = max(0, usr.Force*1.25-M.Durability)
					M.TakeDamage(Damage, usr)
					del(O2)
				sleep(1)
		Reload()
			set category = "Combat"
			if(src.Blasts == 6)
				usr << "You already have enough blasts."
				return
			if(src.Blasts < 6)
				usr.Frozen = 1
				usr << "You begin to reload your blaster."
				sleep(10)
				usr << "You have finished reloading."
				usr.Frozen = 0
				Blasts = 6


obj/Blaster_Rifle
	icon = 'Blaster.dmi'
	var/Equipped = 0
	var/Blasts = 5
	var/ChargeCD = 0

	Click()
		if(src in usr.contents)
			if(Equipped == 0)
				usr.overlays+=src.icon
				Equipped = 1
				suffix = "**Equipped**"
			else
				usr.overlays-=src.icon
				Equipped = 0
				suffix = ""
	verb
		BlastRifle()
			set category = "Combat"
			if(Blasts < 1)
				return
			flick("Attack",usr)
			Blasts -= 1
			usr << "You have [Blasts] blasts left."
			var/obj/O = new /obj/Beam(usr.loc)
			O.icon_state = null
			O.dir = usr.dir
			while(O)
				step(O, O.dir)
				var/turf/Y = get_step(O, O.dir)
				if(!Y)  // If the projectile hits the end of the map...
					del(O)
					break
				for(var/mob/M in get_step(O, O.dir))
					if(M == usr)
						continue
					var/Damage = max(0, usr.Force*1.5-M.Durability)
					M.TakeDamage(Damage, usr)
					del(O)
				sleep(0.5)
		Reload()
			set category = "Combat"
			if(src.Blasts == 5)
				usr << "You already have enough blasts."
				return
			if(src.Blasts < 5)
				usr.Frozen = 1
				usr << "You begin to reload your blaster."
				sleep(20)
				usr << "You have finished reloading."
				usr.Frozen = 0
				Blasts = 5

obj/Blaster
	icon = 'Blaster.dmi'
	var/Equipped = 0
	var/Blasts = 20
	var/ChargeCD = 0

	Click()
		if(src in usr.contents)
			if(Equipped == 0)
				usr.overlays+=src.icon
				Equipped = 1
				suffix = "**Equipped**"
			else
				usr.overlays-=src.icon
				Equipped = 0
				suffix = ""
	verb
		Blast()
			set category = "Combat"
			if(Blasts < 1)
				return
			flick("Attack",usr)
			Blasts -= 1
			usr << "You have [Blasts] blasts left."
			var/obj/O = new /obj/Beam(usr.loc)
			O.icon_state = null
			O.dir = usr.dir
			while(O)
				step(O, O.dir)
				var/turf/Y = get_step(O, O.dir)
				if(!Y)  // If the projectile hits the end of the map...
					del(O)
					break
				for(var/mob/M in get_step(O, O.dir))
					if(M == usr)
						continue
					var/Damage = max(0, usr.Force-M.Durability)
					M.TakeDamage(Damage, usr)
					del(O)
				sleep(1)
		Charge_Blast()
			set category = "Combat"
			if(ChargeCD == 1 || Blasts < 5)
				return
			flick("HeavyAttack", usr)
			ChargeCD = 1
			Blasts -= 5
			usr << "You have [Blasts] blasts left."
			var/beamloc
			if(usr.dir == 1 || usr.dir == 2)
				beamloc = locate(usr.x-1, usr.y, usr.z)
			if(usr.dir == 4 || usr.dir == 8)
				beamloc = locate(usr.x, usr.y-1, usr.z)
			var/obj/O = new /obj/ChargeBeam(beamloc)
			O.icon_state = null
			O.dir = usr.dir
			var/life = 0
			while(O)
				if(life == 300)
					ChargeCD = 0
					del(O)
					return
				step(O, O.dir)
				var/turf/Y = get_step(O, O.dir)
				if(!Y)
					del(O)
					break
				for(var/mob/M in get_step(O, O.dir))
					if(M == usr)
						continue
					var/Damage = max(0, usr.Force-M.Durability)
					M.BlastTakeHeavyDamage(Damage, usr)
					del(O)
				life += 1
				sleep(1)
		Reload()
			set category = "Combat"
			if(src.Blasts == 20)
				usr << "You already have enough blasts."
				return
			if(src.Blasts < 20)
				usr.Frozen = 1
				usr << "You begin to reload your blaster."
				sleep(10)
				usr << "You have finished reloading."
				usr.Frozen = 0
				Blasts = 20

obj/Beam
	icon = 'BlasterBeam.dmi'
obj/ChargeBeam
	icon = 'ChargeblasterBeam.dmi'
obj/ForcePush
	icon = 'ForcePush.dmi'

mob/Rebel/verb
	Push()
		set category = "Combat"
		for(var/mob/M in get_step(usr, usr.dir))
			step(M, usr.dir)
			step(M, usr.dir)
			step(M, usr.dir)
			return
mob/Force/verb
	Force_Switch()
		if(usr.Pushpull == 1)
			usr.Pushpull = 2
			usr << output("You are now using Pull", "OOC")
			return
		if(usr.Pushpull == 2)
			usr.Pushpull = 1
			usr << output("You are now using Push", "OOC")
			return

	Force_PushPull()
		set category = "Combat"
		flick("Attack", usr)
		if(usr.Pushpull == 1)
			var/obj/O = new/obj/ForcePush(usr.loc)
			O.dir = usr.dir
			var/life = 0
			while(O)
				if(life == 300)
					del(O)
				step(O, O.dir)
				var/turf/Y = get_step(O, O.dir)
				if(!Y)
					del(O)
					break
				for(var/mob/M in get_step(O, O.dir))
					if(M == usr)
						continue
					step(M, O.dir)
					sleep(0.5)
					step(M, O.dir)
					sleep(0.5)
					step(M, O.dir)
					sleep(0.5)
					step(M, O.dir)
					sleep(0.5)
					step(M, O.dir)
					sleep(0.5)
					del(O)
				life += 1
				sleep(1)
		if(usr.Pushpull == 2)
			if(client.target == null)
				return
			flick("Attack", usr)

			var/mob/A = client.target

			if(usr.Force > A.Force)
				usr.Frozen = 1
				A.Frozen = 1
				var/dest
				if(usr.dir == 1)
					dest = locate(usr.x, usr.y+1, usr.z)
				if(usr.dir == 2)
					dest = locate(usr.x, usr.y-1, usr.z)
				if(usr.dir == 4)
					dest = locate(usr.x+1, usr.y, usr.z)
				if(usr.dir == 8)
					dest = locate(usr.x-1, usr.y, usr.z)
				while(A.loc != dest)
					walk_towards(A, dest)
					sleep(0.5)
				A.Frozen = 0
				usr.Frozen = 0
	Force_Freeze()
		set category = "Combat"
		flick("Attack", usr)
		var/obj/O = new/obj/ForcePush(usr.loc)
		O.dir = usr.dir
		var/life = 0
		while(O)
			if(life == 300)
				del(O)
			step(O, O.dir)
			var/turf/Y = get_step(O, O.dir)
			if(!Y)
				del(O)
				break
			for(var/mob/M in get_step(O, O.dir))
				if(M == usr)
					continue
				del(O)
				M.Frozen = 1
				sleep(50)
				M.Frozen = 0
			life += 1
			sleep(1)

	Force_Choke()
		set category = "Combat"
		flick("Attack", usr)
		var/obj/O = new/obj/ForcePush(usr.loc)
		O.dir = usr.dir
		var/life = 0
		while(O)
			if(life == 300)
				del(O)
			step(O, O.dir)
			var/turf/Y = get_step(O, O.dir)
			if(!Y)
				del(O)
				break
			for(var/mob/M in get_step(O, O.dir))
				if(M == usr)
					continue
				del(O)
				if(usr.Force > M.Force)
					M.Frozen = 1
					usr.Frozen = 1
					var/dmg = usr.Force*0.50-M.Durability
					var/duration = 2
					spawn(1)
						var/oldeye=M.client.eye
						var/x
						for(x=0;x<duration,x++)
							M.client.eye = get_step(M,pick(NORTH,SOUTH,EAST,WEST))
							sleep(1)
						M.client.eye=oldeye
					M.HP -= dmg
					sleep(10)
					spawn(1)
						var/oldeye=M.client.eye
						var/x
						for(x=0;x<duration,x++)
							M.client.eye = get_step(M,pick(NORTH,SOUTH,EAST,WEST))
							sleep(1)
						M.client.eye=oldeye
					M.HP -= dmg
					sleep(10)
					spawn(1)
						var/oldeye=M.client.eye
						var/x
						for(x=0;x<duration,x++)
							M.client.eye = get_step(M,pick(NORTH,SOUTH,EAST,WEST))
							sleep(1)
						M.client.eye=oldeye
					M.HP -= dmg
					M.Frozen = 0
					usr.Frozen = 0
				else
					return
			life+=1
			sleep(1)


var/list/RevDir = list(2,1,,8,10,9,,4,6,5)

var/mob/admins = list()

mob


	Login()
		..()
		if(src.key=="Nero321"||src.key=="NotJ3M"||src.key=="") //your key(s) go in between the ""
			src.verbs+=typesof(/mob/Admin/verb)
			if(!(usr.key in admins))
				admins+=src
			if(usr.key in admins)
				return


mob/Admin/verb


	Check_Player_Inventory()
		set category = "Staff"
		var/list/Players = list()
		for(var/mob/O in world)
			Players.Add(O)
		var/mob/A = input("Select a Player!") in Players

		var/obj/O = input("Which Item?") in A.contents

		var/L = input("Options") in list("Delete", "Edit", "Copy", "Cancel")

		if(L == "Edit")
			var/variable = input("Which var?","Var") in O.vars
			var/default
			var/typeof = O.vars[variable]
			if(isnull(typeof))
				usr << "Unable to determine variable type."
			else if(isnum(typeof))
				usr << "Variable appears to be <b>NUM</b>."
				default = "num"
			else if(istext(typeof))
				usr << "Variable appears to be <b>TEXT</b>."
				default = "text"
			else if(isloc(typeof))
				usr << "Variable appears to be <b>REFERENCE</b>."
				default = "reference"
			else if(isicon(typeof))
				usr << "Variable appears to be <b>ICON</b>."
				typeof = "\icon[typeof]"
				default = "icon"
			else if(istype(typeof,/atom) || istype(typeof,/datum))
				usr << "Variable appears to be <b>TYPE</b>."
				default = "type"
			else if(istype(typeof,/list))
				usr << "Variable appears to be <b>LIST</b>."
				usr << "*** Warning!  Lists are uneditable in s_admin! ***"
				default = "cancel"
			else if(istype(typeof,/client))
				usr << "Variable appears to be <b>CLIENT</b>."
				usr << "*** Warning!  Clients are uneditable in s_admin! ***"
				default = "cancel"
			else
				usr << "Variable appears to be <b>FILE</b>."
				default = "file"
			usr << "Variable contains: [typeof]"
			var/class = input("What kind of variable?","Variable Type",default) in list("text",
				"num","type","reference","icon","file","restore to default","cancel")
			switch(class)
				if("cancel")
					return
				if("restore to default")
					O.vars[variable] = initial(O.vars[variable])
				if("text")
					O.vars[variable] = input("Enter new text:","Text",\
						O.vars[variable]) as text
				if("num")
					O.vars[variable] = input("Enter new number:","Num",\
						O.vars[variable]) as num
				if("type")
					O.vars[variable] = input("Enter type:","Type",O.vars[variable]) \
						in typesof(/mob)
				if("reference")
					O.vars[variable] = input("Select reference:","Reference",\
						O.vars[variable]) as mob|obj|turf|area in world
				if("file")
					O.vars[variable] = input("Pick file:","File",O.vars[variable]) \
						as file
				if("icon")
					O.vars[variable] = input("Pick icon:","Icon",O.vars[variable]) \
						as icon
			if(L == "Delete")
				A.contents-=O

			if(L == "Copy")
				usr.contents+=O

			if(L == "Cancel")
				return


	Edit(obj/O as mob in world)//this verbs allows you to edit vars of players/mobs.
		set category = "Staff"
		var/variable = input("Which var?","Var") in O.vars
		var/default
		var/typeof = O.vars[variable]
		if(isnull(typeof))
			usr << "Unable to determine variable type."
		else if(isnum(typeof))
			usr << "Variable appears to be <b>NUM</b>."
			default = "num"
		else if(istext(typeof))
			usr << "Variable appears to be <b>TEXT</b>."
			default = "text"
		else if(isloc(typeof))
			usr << "Variable appears to be <b>REFERENCE</b>."
			default = "reference"
		else if(isicon(typeof))
			usr << "Variable appears to be <b>ICON</b>."
			typeof = "\icon[typeof]"
			default = "icon"
		else if(istype(typeof,/atom) || istype(typeof,/datum))
			usr << "Variable appears to be <b>TYPE</b>."
			default = "type"
		else if(istype(typeof,/list))
			usr << "Variable appears to be <b>LIST</b>."
			usr << "*** Warning!  Lists are uneditable in s_admin! ***"
			default = "cancel"
		else if(istype(typeof,/client))
			usr << "Variable appears to be <b>CLIENT</b>."
			usr << "*** Warning!  Clients are uneditable in s_admin! ***"
			default = "cancel"
		else
			usr << "Variable appears to be <b>FILE</b>."
			default = "file"
		usr << "Variable contains: [typeof]"
		var/class = input("What kind of variable?","Variable Type",default) in list("text",
			"num","type","reference","icon","file","restore to default","cancel")
		switch(class)
			if("cancel")
				return
			if("restore to default")
				O.vars[variable] = initial(O.vars[variable])
			if("text")
				O.vars[variable] = input("Enter new text:","Text",\
					O.vars[variable]) as text
			if("num")
				O.vars[variable] = input("Enter new number:","Num",\
					O.vars[variable]) as num
			if("type")
				O.vars[variable] = input("Enter type:","Type",O.vars[variable]) \
					in typesof(/mob)
			if("reference")
				O.vars[variable] = input("Select reference:","Reference",\
					O.vars[variable]) as mob|obj|turf|area in world
			if("file")
				O.vars[variable] = input("Pick file:","File",O.vars[variable]) \
					as file
			if("icon")
				O.vars[variable] = input("Pick icon:","Icon",O.vars[variable]) \
					as icon

	EditTechs(obj/O in world)
		set category = "Staff"
		var/variable = input("Which var?","Var") in O.vars
		var/default
		var/typeof = O.vars[variable]
		if(isnull(typeof))
			usr << "Unable to determine variable type."
		else if(isnum(typeof))
			usr << "Variable appears to be <b>NUM</b>."
			default = "num"
		else if(istext(typeof))
			usr << "Variable appears to be <b>TEXT</b>."
			default = "text"
		else if(isloc(typeof))
			usr << "Variable appears to be <b>REFERENCE</b>."
			default = "reference"
		else if(isicon(typeof))
			usr << "Variable appears to be <b>ICON</b>."
			typeof = "\icon[typeof]"
			default = "icon"
		else if(istype(typeof,/atom) || istype(typeof,/datum))
			usr << "Variable appears to be <b>TYPE</b>."
			default = "type"
		else if(istype(typeof,/list))
			usr << "Variable appears to be <b>LIST</b>."
			usr << "*** Warning!  Lists are uneditable in s_admin! ***"
			default = "cancel"
		else if(istype(typeof,/client))
			usr << "Variable appears to be <b>CLIENT</b>."
			usr << "*** Warning!  Clients are uneditable in s_admin! ***"
			default = "cancel"
		else
			usr << "Variable appears to be <b>FILE</b>."
			default = "file"
		usr << "Variable contains: [typeof]"
		var/class = input("What kind of variable?","Variable Type",default) in list("text",
			"num","type","reference","icon","file","restore to default","cancel")
		switch(class)
			if("cancel")
				return
			if("restore to default")
				O.vars[variable] = initial(O.vars[variable])
			if("text")
				O.vars[variable] = input("Enter new text:","Text",\
					O.vars[variable]) as text
			if("num")
				O.vars[variable] = input("Enter new number:","Num",\
					O.vars[variable]) as num
			if("type")
				O.vars[variable] = input("Enter type:","Type",O.vars[variable]) \
					in typesof(/mob)
			if("reference")
				O.vars[variable] = input("Select reference:","Reference",\
					O.vars[variable]) as mob|obj|turf|area in world
			if("file")
				O.vars[variable] = input("Pick file:","File",O.vars[variable]) \
					as file
			if("icon")
				O.vars[variable] = input("Pick icon:","Icon",O.vars[variable]) \
					as icon



	Teleport()//this verb allows you to teleport to a player currently online or to a location on the map using x,y,z.
		set category = "Staff"
		switch(input("Please select a method of Teleportation!") in list("Location","Player","Teleport someone else","Cancel"))
			if("Location")
				loc = locate(input("X") as num,input("Y") as num,input("Z") as num)
			if("Player")
				var/list/Players = list()
				for(var/mob/M in world)
					Players.Add(M)
				var/mob/M = input("Select a Player!") in Players
				loc = M.loc
			if("Teleport someone Else")
				var/Teleport = locate(input("X") as num,input("Y") as num,input("Z") as num)
				var/list/Players = list()
				for(var/mob/M in world)
					Players.Add(M)
				var/mob/M = input("Select a Player!") in Players
				M.loc = Teleport


	Boot()//this verb will boot a player from your game.
		set category = "Staff"
		var/Reason = input("Give a reason!") as text
		if(Reason == "")return
		var/list/Players = list()
		for(var/mob/M in world)
			Players.Add(M)
		var/mob/M = input("Select a Player!") in Players
		world<<output("<b><font size = +1 color = red>[M] was booted for [Reason]</font></b>", "OOC")
		del(M)

	Reboot()//this verb reboots the server.
		set category = "Staff"
		if(alert("You wish to continue?","","No","Yes") == "No")return
		if("Yes")
			world<<output("<b><font size= 2><font color=red><center>Rebooting..</b></font></center>", "OOC")
		world.Reboot()


	Delete(M as mob|obj|turf in view(src))//this verb allows you to delete a mob/obj/turf.
		set category = "Staff"
		del(M)

	Rename(mob/M as mob in world, ID as text)//this verb allows you to rename a player currently online.
		set category="Staff"
		for(var/mob/N in world)
			if(N.name==""||N.name==null||N.name==0)
				N.name="NameLess"
				usr<<output("<font color=red>Found Nameless. Renamed to NameLess. Key: [N.key]", "OOC")
		M.name=ID
		usr<<output("You <font color = blue>changed</font> [M]'s name.", "OOC")
		return


	World_Info()//this verb shows you the server info.
		set category="Staff"
		set name = "World Info"
		set desc = "See the server's information"
		usr<<output("* Server information *", "OOC")
		usr<<output("CPU Usage\t: [world.cpu]", "OOC")
		usr<<output("Uptime\t\t: [(world.time)]", "OOC")
		usr<<output("Status\t\t: <br>\[[world.status]]", "OOC")