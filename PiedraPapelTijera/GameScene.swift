//
//  GameScene.swift
//  PiedraPapelTijera
//
//  Created by Desarrollo Uxi on 06/01/17.
//  Copyright © 2017 Alberto. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var soundWin: SKAction!
    var soundFall: SKAction!
    var sounIntro: SKAction!
    var sounIntroD : SKAction!
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var fondo : SKSpriteNode!
    
    var labelScoreUser :SKLabelNode!
    var labelScoreMaquina : SKLabelNode!
    var scoreUser:Int = 0
    var scoremaquina:Int = 0
    
    var labelInit: SKLabelNode!
    var labelPiedra: SKLabelNode!
    var labelPapel: SKLabelNode!
    var labelTijera: SKLabelNode!
    
    var piedraButton: SKSpriteNode!
    var papelButton: SKSpriteNode!
    var tijeraButton: SKSpriteNode!
    var nodeSelected : SKSpriteNode!
    var nodeMaquina : SKSpriteNode!
    
    var isGame :Bool = false
    var elegidoUser : Int!
    var eledigoMaquina : Int!
    
    override func didMove(to view: SKView) {
        self.initGame()
    }
    
    private func initGame(){
        self.addFondo()
        self.addLabel()
        soundWin = SKAction.playSoundFileNamed("ganar.mp3", waitForCompletion: true)
        soundFall = SKAction.playSoundFileNamed("lost.mp3", waitForCompletion: true)
        sounIntro = SKAction.playSoundFileNamed("latigo.mp3", waitForCompletion: true)
        sounIntroD = SKAction.playSoundFileNamed("latigazo.mp3", waitForCompletion: true)
    }
    
    private func addScore(user: Bool, machine: Bool){
        
        let delNodo = SKAction.removeFromParent()
        let showBig = SKAction.scale(to: 1.8, duration: 0.1)
        let secuencia = SKAction.sequence([showBig, delNodo])
        if(self.labelScoreUser != nil && user){
            self.labelScoreUser.run(secuencia)
        }
        if(self.labelScoreMaquina != nil && machine){
            self.labelScoreMaquina.run(secuencia)
        }
        
        if(user){
            labelScoreUser = SKLabelNode(fontNamed: "Noteworthy-Light")
            labelScoreUser.text = "Score = \(self.scoreUser)"
            labelScoreUser.fontSize = 30
            labelScoreUser.fontColor = UIColor.white
            labelScoreUser.position = CGPoint(x: self.frame.minX + 100, y:   self.frame.maxY / 4)
            self.addChild(labelScoreUser)
        }
        if(machine){
            labelScoreMaquina = SKLabelNode(fontNamed: "Noteworthy-Light")
            labelScoreMaquina.text = "Score = \(self.scoremaquina)"
            labelScoreMaquina.fontSize = 30
            labelScoreMaquina.fontColor = UIColor.white
            print(self.frame.minX)
            print(self.frame.maxY)
            labelScoreMaquina.position = CGPoint(x: self.frame.maxX - 100, y:   self.frame.maxY / 4)
            self.addChild(labelScoreMaquina)
        }
    
    }
    
    private func addFondo(){
        fondo = SKSpriteNode(imageNamed: "fondo")
        fondo.position =  CGPoint(x: 0, y: 0 )
        fondo.size =  CGSize(width: self.frame.width, height: self.frame.height)
        fondo.alpha = 0.20
        self.addChild(fondo)
    }
    
    private func addLabel(){
        labelInit = SKLabelNode(fontNamed: "Noteworthy-Light")
        labelInit.text = "Toca para iniciar"
        labelInit.fontSize = 40
        labelInit.fontColor = UIColor.cyan
        labelInit.position = CGPoint(x: 0, y: 0)
        self.addChild(labelInit)
    }
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print(self.isGame)
        if(self.isGame){
            self.isGame = false
            
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let touchedNode = self.nodes(at: touchLocation)
            var posicionNode : CGPoint!
            posicionNode = CGPoint(x:-(self.frame.maxX - 70), y:0)

            if(touchedNode[0].name == "piedraButton"){
                self.mostrarElegido(imageNodo: "piedra", posicion: posicionNode)
                eleccionMaquina()
                self.elegidoUser = 1
                self.comprobarJuego()
            }else if(touchedNode[0].name == "papelButton"){
                self.mostrarElegido(imageNodo: "mano", posicion: posicionNode)
                eleccionMaquina()
                self.elegidoUser = 2
                self.comprobarJuego()
            }else if(touchedNode[0].name == "tijeraButton"){
                eleccionMaquina()
                self.elegidoUser = 3
                self.mostrarElegido(imageNodo: "tijeras", posicion: posicionNode)
                self.comprobarJuego()
            }else{
                self.isGame = true
            }
        }else{
            self.resetGame()
            let secuencia = SKAction.sequence([sounIntro, sounIntro, sounIntroD])
            self.run(secuencia)
            labelInit.run(getSecuencia(), completion: {
                self.showLabelPiedra()
            })
            self.isGame = true
        }
    }
    
    func comprobarJuego()  {
        //1 Piedra, 2 Papel , 3 tijera
        var mensaje :String = ""
        var userGana :Bool = false
        var machineGana : Bool = false
        labelInit = SKLabelNode(fontNamed: "Noteworthy-Light")
        if(self.elegidoUser == self.eledigoMaquina){
            mensaje =  "Empate!"
            labelInit.fontColor = UIColor.gray
        }else if(self.elegidoUser == 1 && self.eledigoMaquina == 2){
            mensaje = "Perdiste =("
            self.scoremaquina = self.scoremaquina + 1
            machineGana = true
            labelInit.fontColor = UIColor.red
            self.run(soundFall)
        }else if(self.elegidoUser == 1 && self.eledigoMaquina == 3){
            mensaje = "Ganaste =)"
            self.scoreUser = self.scoreUser + 1
            labelInit.fontColor = UIColor.green
            userGana = true
            self.run(soundWin)
        }else if(self.elegidoUser == 2 && self.eledigoMaquina == 1){
            mensaje = "Ganaste =)"
            self.scoreUser = self.scoreUser + 1
            labelInit.fontColor = UIColor.green
            userGana = true
            self.run(soundWin)
        }else if(self.elegidoUser == 2 && self.eledigoMaquina == 3){
            mensaje = "Perdiste =("
             self.scoremaquina = self.scoremaquina + 1
            labelInit.fontColor = UIColor.red
            machineGana = true
            self.run(soundFall)
        }else if(self.elegidoUser == 3 && self.eledigoMaquina == 1){
            mensaje = "Perdiste =("
             self.scoremaquina = self.scoremaquina + 1
            labelInit.fontColor = UIColor.red
            machineGana = true
            self.run(soundFall)
        }else if(self.elegidoUser == 3 && self.eledigoMaquina == 2){
            mensaje = "Ganaste =)"
            self.scoreUser = self.scoreUser + 1
            labelInit.fontColor = UIColor.green
            userGana = true
            self.run(soundWin)
        }
        self.addScore(user: userGana, machine: machineGana)
        labelInit.text = mensaje
        labelInit.fontSize = 60
        
        labelInit.position = CGPoint(x: 0, y: 0)
        self.addChild(labelInit)

    }
    
    func mostrarElegido(imageNodo: String, posicion: CGPoint ){
        nodeSelected = SKSpriteNode(imageNamed: imageNodo)
        nodeSelected.position = posicion
        nodeSelected.size = CGSize(width: 150, height: 150)
        self.addChild(nodeSelected)
    }
    func mostrarMaquina(imageNodo: String, posicion: CGPoint ){
        nodeMaquina = SKSpriteNode(imageNamed: imageNodo)
        nodeMaquina.position = posicion
        nodeMaquina.size = CGSize(width: 150, height: 150)
        self.addChild(nodeMaquina)
    }
    func showLabelPiedra() {
        labelPiedra = getLabel(texto: "Piedra", fontS: 30, zposition: 15, color: .red)
        self.addChild(labelPiedra)
        
        labelPiedra.run(getSecuencia(), completion: {
            self.showLabelPapel()
        })
    }
    
    func showLabelPapel() {
        labelPapel = getLabel(texto: "Papel", fontS: 40, zposition: 10, color: .yellow)
        self.addChild(labelPapel)
        
        labelPapel.run(getSecuencia(), completion: {
            self.showLabelTijera()
        })
    }
    
    func showLabelTijera() {
        labelTijera = getLabel(texto: "Tijera", fontS: 60, zposition: 5, color: .green)
        self.addChild(labelTijera)
        
        labelTijera.run(getSecuencia(), completion: {
            self.piedraButton = self.getBtn(imgName: "piedra", xPosicion: -100, nameBtn: "piedraButton")
            self.addChild(self.piedraButton)
            self.papelButton = self.getBtn(imgName: "mano", xPosicion: 0, nameBtn: "papelButton")
            self.addChild(self.papelButton)
            self.tijeraButton = self.getBtn(imgName: "tijeras", xPosicion: 100, nameBtn: "tijeraButton")
            self.addChild(self.tijeraButton)
        })
    }
    private func getBtn(imgName: String, xPosicion: Int,nameBtn:String ) -> SKSpriteNode{
        var btn : SKSpriteNode!
        btn = SKSpriteNode(imageNamed: imgName)
        btn.position = CGPoint(x: xPosicion, y: -150)
        btn.size = CGSize(width: 70, height: 70)
        btn.name = nameBtn
        //print(btn)
        //self.addChild(btn)
        return btn
    }
    
    private func getLabel(texto: String, fontS: Int, zposition: Int, color: UIColor) -> SKLabelNode {
        var label: SKLabelNode!
        label = SKLabelNode(fontNamed: "Noteworthy-Light")
        label.text = texto
        label.fontSize = CGFloat(fontS)
        label.zPosition = CGFloat(zposition)
        label.fontColor = color
        label.position = CGPoint(x: 0, y: 0)
        return label
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    private func eleccionMaquina(){
        let max = 3
        let min = 1
        let eleccionMaquina : Int = Int(arc4random_uniform(UInt32((max - min ) +  min))) + min
        var posicionNode : CGPoint!
        posicionNode = CGPoint(x: (self.frame.maxX - 70), y:0)
        if(eleccionMaquina == 1){
            self.eledigoMaquina = 1
            self.mostrarMaquina(imageNodo: "piedra", posicion: posicionNode)
        }else if(eleccionMaquina == 2){
            self.eledigoMaquina = 2
            self.mostrarMaquina(imageNodo: "mano", posicion: posicionNode)
        }else{
            self.eledigoMaquina = 3
         self.mostrarMaquina(imageNodo: "tijeras", posicion: posicionNode)
        }
    }
    
    private func getSecuencia() -> SKAction {
        let showBig = SKAction.scale(to: 1.8, duration: 0.01)
        let showSmall = SKAction.scale(to: 0.1, duration: 0.01)
        let shadow = SKAction.fadeOut(withDuration: 0.01)
        let secuencia = SKAction.sequence([showBig, showSmall, shadow])
        return secuencia
    }
    
    func resetGame() {
        let delNodo = SKAction.removeFromParent()

        if(self.piedraButton != nil){
            self.piedraButton.run(delNodo)
        }
        if(self.papelButton != nil){
            self.papelButton.run(delNodo)
        }
        if(self.tijeraButton != nil){
            self.tijeraButton.run(delNodo)
        }
        if(self.nodeSelected != nil){
            self.nodeSelected.run(delNodo)
        }

        if(self.nodeMaquina != nil){
            self.nodeMaquina.run(delNodo)
        }
        
    }
    
}
