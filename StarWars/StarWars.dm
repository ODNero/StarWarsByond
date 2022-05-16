/*
	These are simple defaults for your project.
 */

world
	fps = 25		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default

	view = 6		// show up to 6 tiles outward from center (13x13 view)
turf
	sand
		icon = 'sand.dmi'


// Make objects move 8 pixels per tick when walking

client
	Move(atom/loc,dir)

		return mob.canMove(loc,dir)&&..()

mob
	step_size = 8
	icon = 'Base_Tan.dmi'

	var
		HP = 100
		MaxHP = 100
		Stamina = 100
		MaxStam = 100
		Strength = 1
		Reflex = 1
		Durability = 1
		AttackSpeed = 1


		Parryable = 0
		Parried = 0

		KnockedOut = 0


		Frozen
	verb
		Attack() //Regular attack
			flick("Attack",usr)

		Heavy_Attack() //Heavy attack the breaks guard
			if(KnockedOut == 1)
				return
			if(HP <= 0)
				return
			if(Frozen == 1)
				return
			flick("HeavyAttack", usr)
			for(var/mob/M in get_step(src,src.dir))
				usr.Stamina -= 10
				usr.Parryable = 1
				sleep(5)
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




		Block() //Used to block incoming attacks including blasters, broken by heavy attacks

		Parry() //Parries attacks when timed correctly
			flick("Attack", usr)
			for(var/mob/M in get_step(src, src.dir))
				if(M.Parryable == 1)
					M.Parried = 1

	proc
		TakeDamage(var/Damage, var/mob/Attacker)
			if(src.HP <= 0)
				return
			else
				src.HP-=Damage
				src.KOCheck(Attacker)

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
			else
				return

		canMove(atom/NewLoc,Dir=0)
			return !Frozen

mob/Stat()
	statpanel("Status")
	stat(usr)
	stat("Health:", "[MaxHP]/[HP]")
	stat("Stamina:", "[MaxStam]/[Stamina]")
	stat("Strength:", "[Strength]")
	stat("Durability:", "[Durability])")
	stat("Attack Speed:", "[AttackSpeed]")
	stat("Reflex:", "[Reflex]")
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