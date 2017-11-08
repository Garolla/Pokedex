//
//  Pokemon.swift
//  Pokedex
//
//  Created by Emanuele Garolla on 29/08/2017.
//  Copyright © 2017 Emanuele Garolla. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name : String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolTxt: String!
    private var _nextEvolName: String!
    private var _nextEvolLevel: String!
    private var _nextEvolID: String!
    
    private var _pokemonURL: String!
    
    var nextEvolName: String {
        if _nextEvolName == nil {
            _nextEvolName = ""
        }
        return _nextEvolName
    }
    
    var nextEvolLevel: String {
        if _nextEvolLevel == nil {
            _nextEvolLevel = ""
        }
        return _nextEvolLevel
    }
    
    var nextEvolID: String {
        if _nextEvolID == nil {
            _nextEvolID = ""
        }
        return _nextEvolID
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolTxt: String {
        if _nextEvolTxt == nil {
            _nextEvolTxt = ""
        }
        return _nextEvolTxt
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func donwloadPokemonDetail(completed: @escaping DownloadComplete){
        
        Alamofire.request(_pokemonURL).responseJSON{ (response) in
            //            print(response.result.value as Any)
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict ["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict ["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                print(self._weight)
                print(self._attack)
                print(self._height)
                print(self._defense)
                
                
                self._type = ""
                
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                    
                    for x in 0..<types.count {
                        if let name = types[x]["name"] {
                            self._type! += "\(name.capitalized)/"
                        }
                    }
                    //Remove the last /
                    self._type.remove(at: self._type.index(before: self._type.endIndex))
                    print(self._type)
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String,String>] , descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        let descURL = "\(URL_BASE)\(url)"
                        Alamofire.request(descURL).responseJSON{ (response) in
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    //                                    print(newDescription)
                                    self._description = newDescription
                                }
                            }
                            completed()
                        }
                    }
                    
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] , evolutions.count > 0 {
                    if let nextEvo = evolutions[0]["to"] as? String {
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvolName = nextEvo
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoID = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolID = nextEvoID
                                if let lvlExist = evolutions[0]["level"] {
                                    if let lvl = lvlExist as? Int {
                                        self._nextEvolLevel = "\(lvl)"
                                    }
                                } else {
                                    self._nextEvolLevel = ""
                                }
                            }
                        }
                    }
                    print(self.nextEvolLevel)
                    print(self.nextEvolID)
                    print(self.nextEvolName)
                    
                }
                
            }
            
            completed()
        }
    }
}
