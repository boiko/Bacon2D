/**
 * Copyright (C) 2012 by INdT
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 *
 * @author Rodrigo Goncalves de Oliveira <rodrigo.goncalves@openbossa.org>
 * @author Roger Felipe Zanoni da Silva <roger.zanoni@openbossa.org>
 */

Game {
    id: game

    width: 800
    height: 600

    currentScene: scene

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Scene {
        id: scene

        width: parent.width
        height: parent.height

        onContactPostSolve: {
            var impulse = contact.maxImpulse
            var fixtureA = contact.fixtureA
            var fixtureB = contact.fixtureB

            if (impulse > 500.0 && (fixtureA.entity == mouseItem || fixtureB.entity == mouseItem)) {
                if (fixtureA.entity == mouseItem)
                    fixtureB.entity.destroy()
                else
                    fixtureA.entity.destroy()
            }
        }

        Entity {
            id: mouseItem

            width: 60
            height: 60

            entityType: Bacon2D.DynamicType

            Fixture {
                width: parent.width
                height: parent.height

                material: randomMaterial

                shape: Box {
                    width: parent.width
                    height: parent.height

                    fill: ColorFill {
                        brushColor: "green"
                    }
                }
            }

            sleepingAllowed: false

            x: 200
            y: 160
        }

        MouseJoint {
            target: mouseItem
        }

        Entity {
            id: ground

            entityType: Bacon2D.StaticType

            width: 790
            height: 5

            Fixture {
                anchors.fill: parent
                material: randomMaterial
                shape: Box {
                    anchors.fill: parent
                    fill: ColorFill {
                        brushColor: "green"
                    }
                }
            }

            x: 0
            y: 500
        }
    }

    Material {
        id: randomMaterial

        friction: 0.3 + Math.random() * 1.0
        density: 5 + Math.random() * 10
        restitution: 0.5 + Math.random() * 0.5
    }

    Component {
        id: bodyComponent

        Entity {
            id: body

            width: 30
            height: 30
            x: Math.random() * scene.width
            y: Math.random() * 200

            entityType: Bacon2D.DynamicType
            sleepingAllowed: false

            Fixture {
                material: randomMaterial

                shape: Circle {
                    anchors.fill: parent

                    fill: ColorFill {
                        brushColor: "red"
                    }
                }
            }

            onXChanged: {
                if (body.x > scene.width || x < -body.width)
                    body.destroy()
            }

            onYChanged: {
                if (body.y > scene.height)
                    body.destroy()
            }
        }
    }

    Timer {
        //interval: 1500; running: true; repeat: true
        onTriggered: bodyComponent.createObject(scene)
    }

    Component.onCompleted: {
        for (var i = 0; i < 1; i++) {
            bodyComponent.createObject(scene)
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: bodyComponent.createObject(scene)
    }
}
