//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Emanuele Garolla on 29/08/2017.
//  Copyright © 2017 Emanuele Garolla. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descrLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var pokeIDLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var weigthLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var evolLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name.capitalized
        pokeIDLbl.text = "\(pokemon.pokedexId)"
        
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        
        
        
        pokemon.donwloadPokemonDetail {
            //This code will be called after the network call is complete
            print("Arrived")
            self.updateUI()
        }
    }
    
    func updateUI(){
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weigthLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        descrLbl.text = pokemon.description
        
        if pokemon.nextEvolID == "" {
            evolLbl.text = "No evolutions"
            nextEvoImg.isHidden = true
        } else {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolID)
            let str = "Next Evolution: \(pokemon.nextEvolName) - LVL \(pokemon.nextEvolLevel)"
            evolLbl.text = str
        }
        
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
