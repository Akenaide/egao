package com.example.wselpairingsystem
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import kotlinx.android.synthetic.main.activity_main.*
import kotlinx.android.synthetic.main.tournament.*
import java.util.*
class MainActivity : AppCompatActivity() {
    var ListOfPlayers = mutableMapOf<Int,Player>()
    var ListOfRound = mutableListOf<Round>()
    var currentMatch = 0
    var currentRound = 0
    // Partie qui génère l'appli
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }
    // Fonction appelée par le bouton qui sert à add un joueur
    fun okButtonTouched(button:View) {

        ListOfPlayers.put(ListOfPlayers.size+1,Player(firstNameBox.text.toString(),lastN
        ameBox.text.toString(),WSELCodeBox.text.toString(),nicknameBox.text.toString
        (),serieBox.text.toString(),ListOfPlayers.size+1))
        mainLabel.text = ListOfPlayers.get(ListOfPlayers.size)?.fullName()+" a été
        ajouté (${ListOfPlayers.size} joueurs)"
        refreshPlayerList()
    }
    // Rafraichissement visuel de la liste de joueur sur le premier écran
    fun refreshPlayerList() {
        var list = ""
        for(player in ListOfPlayers) {
            list += player.value.fullName()+" (ID : ${player.value.ID})\n"
        }
        playerList.text = list
    }
    // Gestion de l'appui pour démarrer le tournoi et générer la première ronde
    fun onStartTouched(button:View) {
        // Si on a un nombre de joueur impair, on rajoute le joueur "BYE")
        if(ListOfPlayers.size%2==1)
        ListOfPlayers.put(ListOfPlayers.size+1,Player("BYE","","","","",ListOfPlayers.size+
        1))

        // Génération de la première round
        var matchList = newRound()
        var firstRound:Round = Round()

        // Le round et sa liste de match sont ajoutés à la list des rounds, pour
        garder un historique des rounds pour la gestion d'historique
        firstRound.matchlist=matchList
        ListOfRound.add(firstRound)

        //Changement de page pour passer en gestion du tournoi
        setContentView(R.layout.tournament)

        // Gestion procédurale des boutons pour avoir des duos [J1] [J2] pour
        chaque match, du coup à priori tu t'en fout
        for(i in (1..ListOfPlayers.size)) {
            var nouveaubouton:Button = Button(linearLayout.context)
            if(i%2==1) {
                nouveaubouton.text = firstRound.matchlist.get((i - 1) /
                2).p1?.fullName()
            } else {
                nouveaubouton.text = firstRound.matchlist.get((i - 1) /
                2).p2?.fullName()
            }
            nouveaubouton.visibility = View.VISIBLE
            nouveaubouton.translationX+=200
            if(i%2==0) nouveaubouton.translationX+=400
            nouveaubouton.translationY+=(i-(i-1)%2)*50
            nouveaubouton.setOnClickListener(object : View.OnClickListener {
                override fun onClick(v: View?) {
                    onPlayerButtonTouched(nouveaubouton)
                }
            })
            linearLayout?.addView(nouveaubouton)
            firstRound.matchlist.get((i-1)/2).matchButtons.add(nouveaubouton)
        }
    }
    // Quand on clique sur un joueur, il est désigné gagnant du match. Le
    changement de textsize sert juste au debugging
    fun onPlayerButtonTouched(button:Button) {
        for(match in ListOfRound.get(currentRound).matchlist) {
            if(match.p1?.fullName()==button.text) {
                match.matchButtons.get(0).textSize=12.toFloat()
                match.matchButtons.get(1).textSize=8.toFloat()
                match.winner=match.p1?.fullName()
            } else if(match.p2?.fullName()==button.text) {
                match.matchButtons.get(0).textSize=8.toFloat()
                match.matchButtons.get(1).textSize=12.toFloat()
                match.winner=match.p2?.fullName()
            }
        }
    }
    // newRound génère une liste de match à partir de la liste des joueurs en
    variable globale, passe la en paramètre si tu préfères
    fun newRound():MutableList<Match> {

        var resultList = mutableListOf<Match>() // Liste de match à retourner à
        la fin
        var playerList = mutableListOf<Player>() // Liste des joueurs locale pour
        ordonner pour les pairings
        // On génère une liste de tous les entiers de 1 à [nombre de joueurs] qu'on
        mélange, comme ça on distribue ces entiers uniques à chaque joueur pour
        départager en 4eme tie break
        val rnglist = (1..ListOfPlayers.size).shuffled()
        for (player in ListOfPlayers.values) {
            player.rng = rnglist.get(player.ID-1)
            if(player.firstName=="BYE") player.rng=0
            playerList.add(player)
        }

        // On trie les joueurs par ordre décroissant. player.compareTo(player) est
        surchargé pour que la comparaison se face sur le score, s'il est égal, sur le ratio
        de victoire des adversaires, s'il est égal, le ratio de victoire des adversaires des
        adversaires, s'il est égal, l'entier unique RNG
        playerList.sortDescending()

        var swap:Boolean
        var cont=true
        // Boucle de vérification que chaque joueur n'a pas affronté son adversaire.
        Tant qu'on a pas fait une passe sans avoir eu à swap, on continue
        while(cont) {
            swap=false
            for (i in 0..playerList.size / 2 - 1) {
                var k = 0
                // Si le joueur a affronté son adversaire, on swap son adversaire avec
                l'adversaire suivant dans la liste. S'il a joué contre le nouvel adversaire, on
                restore l'ordre, et on swap avec un adversaire après, et bis repetita.
                while (playerList.get(2 * i).listOfOpponent.contains(playerList.get(2 * i
                + 1).ID) && (2 * i + k) <= playerList.size) {
                    if (k != 0) Collections.swap(playerList, i + 1, i + 1 + k)
                    Collections.swap(playerList, i + 1, i + 2 + k)
                    k++
                    swap = true
                }
            }
            for (i in playerList.size / 2..1) {
                var k = 0
                // Après une passe descendante du premier match à l'avant dernier,
                on fait une passe ascendante du dernier au second
                while (playerList.get(2 * i).listOfOpponent.contains(playerList.get(2 * i
                - 1).ID)) {
                    if (k != 0) Collections.swap(playerList, i + 1, i + 1 + k)
                    Collections.swap(playerList, i + 1, i + 2 + k)
                    k++
                    swap = true
                }
            }
            cont=swap
        }

        // La liste de joueur étant maintenant ordonnée comme il faut, on peut
        ranger chaque paire de joueur dans des objets Match qu'on ajoute à la liste
        for (i in (0..ListOfPlayers.size / 2 - 1)) {
            resultList.add(Match(playerList.get(2 * i), playerList.get(2 * i + 1)))
            resultList.get(i).IDmatch=i/2+1
        }

        return resultList
    }
    //Gestion du bouton "Next Round" (attribution des résultats, génération
    nouvelle ronde)
    fun nextRound(button:View) {
        if(currentMatch==0) {
            //On fait une passe sur les matchs pour attribuer les victoires et ajouter
            les adversaires aux listes d'adversaires des joueurs
            for(match in ListOfRound.get(currentRound).matchlist) {
                if(match.p1?.fullName()==match.winner) {
                    match.p1?.result(true,match.p2?.ID)
                    match.p2?.result(false,match.p1?.ID)
                } else if(match.p2?.fullName()==match.winner) {
                    match.p1?.result(false,match.p2?.ID)
                    match.p2?.result(true,match.p1?.ID)
                }
            }
            // Actualisation des ratios de victoires des adversaires, et des
            adversaires des adversaires
            for(player in ListOfPlayers) {
                player.value.refreshOppRates(ListOfPlayers,currentRound)
            }
            for(player in ListOfPlayers) {
                player.value.refreshOppOppRates(ListOfPlayers,currentRound)
            }

            // Faute de meilleure solution, je fais disparaitre mes vieux boutons
            comme un sale. Tu peux ignorer j'imagine.
            for(match in ListOfRound.last().matchlist) {
                match.matchButtons.get(0).visibility= View.GONE
                match.matchButtons.get(1).visibility= View.GONE
            }

            // Nouvealle ronde, nouvelle liste de match
            var matchList = newRound()
            var newround = Round()
            newround.matchlist=matchList
            ListOfRound.add(newround)

            // Génération des boutons, tu t'en fout toujours à priori
            for(i in (1..ListOfPlayers.size)) {
                var nouveaubouton: Button = Button(linearLayout.context)
                if (i % 2 == 1) {
                    nouveaubouton.text = ListOfRound.last().matchlist.get((i - 1) /
                    2).p1?.fullName()
                } else {
                    nouveaubouton.text = ListOfRound.last().matchlist.get((i - 1) /
                    2).p2?.fullName()
                }
                nouveaubouton.visibility = View.VISIBLE
                nouveaubouton.translationX += 200
                if (i % 2 == 0) nouveaubouton.translationX += 400
                nouveaubouton.translationY += (i - (i - 1) % 2) * 50
                nouveaubouton.setOnClickListener(object : View.OnClickListener {
                    override fun onClick(v: View?) {
                        onPlayerButtonTouched(nouveaubouton)
                    }
                })
                linearLayout?.addView(nouveaubouton)
                ListOfRound.last().matchlist.get((i - 1) /
                2).matchButtons.add(nouveaubouton)
            }
            for(match in ListOfRound.last().matchlist) {
                match.matchButtons.get(0).text=match.p1?.fullName()
                match.matchButtons.get(1).text=match.p2?.fullName()
            }
            currentRound++
        }
    }
}
