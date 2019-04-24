package com.example.wselpairingsystem

class Player(var firstName:String, var lastName:String, var WSELCode:String, var serie:String) : Comparable<Player> {

    var nickname = ""
    var ID = 0
    var score = 0
    var oppWinrate = 0.0
    var oppOppWinrate = 0.0
    var listOfOpponent = mutableListOf<Int?>()
    var rng = 0

    constructor(firstName:String,lastName:String,WSELCode:String,nickname:String,serie:String,ID:Int) : this(firstName,lastName,WSELCode,serie) {
        this.nickname = nickname
        this.ID = ID
    }

    fun result(win:Boolean,oppID:Int?) {
        if(win) score++
        listOfOpponent.add(oppID)
    }

    fun fullName():String {
        if(nickname=="") return firstName+" "+lastName
        else return firstName+" \""+nickname+"\" "+lastName
    }

    fun refreshOppRates(players:Map<Int,Player>,roundNumber:Int) {
        for(i in (0..roundNumber)) {
            this.oppWinrate+=players.get(this.listOfOpponent.get(i))!!.score
        }
        this.oppWinrate/=(roundNumber+1)
    }
    fun refreshOppOppRates(players:Map<Int,Player>,roundNumber:Int) {
        for(i in (0..roundNumber)) {
            this.oppOppWinrate+=players.get(this.listOfOpponent.get(i))!!.oppWinrate
        }
        this.oppOppWinrate/=(roundNumber+1)
    }

    override fun compareTo(other: Player): Int {
        if(this.score!=other.score) {
            return this.score.compareTo(other.score)
        } else if(this.oppWinrate!=other.oppWinrate) {
            return this.oppWinrate.compareTo(other.oppWinrate)
        } else if(this.oppOppWinrate!=other.oppOppWinrate) {
            return this.oppOppWinrate.compareTo((other.oppOppWinrate))
        } else return this.rng.compareTo(other.rng)
    }

}
