/**
*
* GameScene.swift
* KokoWalk
* Created by Yuki MIZUNO on 2016/09/04.
*
* Copyright (c) 2016, Harekaze
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice,
*    this list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright notice,
*    this list of conditions and the following disclaimer in the documentation
*     and/or other materials provided with the distribution.
*
* 3. Neither the name of the copyright holder nor the names of its contributors
*    may be used to endorse or promote products derived from this software
*    without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
* THE POSSIBILITY OF SUCH DAMAGE.
*/

import SpriteKit
import GameplayKit

class GameScene: SKScene {
	
	var stateMachines = [GKStateMachine]()
	var characterNodes = [SKSpriteNode]()
	var graphs = [String : GKGraph]()
	
	private var lastUpdateTime : TimeInterval = 0
	private var characterNode: SKSpriteNode?
	
	override func sceneDidLoad() {

		self.lastUpdateTime = 0
		
		self.characterNode = SKSpriteNode(imageNamed: "asisu")

		if let characterNode = self.characterNode {
			characterNode.position = CGPoint(x: -215, y: 315)
			characterNode.name = "Charater"
			characterNode.scale(to: CGSize(width: 268, height: 508))
			characterNode.zPosition = 4
			characterNode.run(SKAction.init(named: "Join")!, withKey: "join")
		}
		
		Timer.scheduledTimer(withTimeInterval: 1.6, repeats: true, block: {
			timer in
			for stateMachine in self.stateMachines {
				if stateMachine.currentState is JoiningState {
					stateMachine.update(deltaTime: 0)
				}
			}
		})

	}
	
	// MARK: - Character addition
	
	func addCharacter(name: String) {
		if characterNodes.count > 15 {
			var minZPosition:CGFloat = 10
			var index: Int = 0
			for (i, characterNode) in characterNodes.enumerated() {
				if characterNode.zPosition == min(minZPosition, characterNode.zPosition) {
					minZPosition = characterNode.zPosition
					index = i
				}
			}
			characterNodes[index].removeFromParent()
			characterNodes.remove(at: index)
			stateMachines.remove(at: index)
		}
		let characterNode = self.characterNode?.copy() as! SKSpriteNode
		characterNode.name = name
		let stateMachine = GKStateMachine(states: [
			JoiningState(characterNode: characterNode),
			WalkingState(characterNode: characterNode),
			StoppingState(characterNode: characterNode),
			ActionState(characterNode: characterNode),
			]
		)
		stateMachine.enter(JoiningState.self)
		self.stateMachines.append(stateMachine)
		self.characterNodes.append(characterNode)

		self.addChild(characterNode)
	}
	
	// MARK: - Character deletion
	
	func clearAll() {
		for characterNode in self.characterNodes {
			characterNode.removeFromParent()
		}
		characterNodes.removeAll()
		stateMachines.removeAll()
	}
	
	// MARK: - Frame update
	
	override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
		
		// Initialize _lastUpdateTime if it has not already been
		if (self.lastUpdateTime == 0) {
			self.lastUpdateTime = currentTime
		}
		
		self.lastUpdateTime = currentTime
		
	}
}
