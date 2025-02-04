"
I can move an element from its position
"
Class {
	#name : #RSDraggable,
	#superclass : #RSInteraction,
	#category : #'Roassal3-Interaction-Core'
}

{ #category : #'instance creation' }
RSDraggable class >> wantsUniqueInstance [
	^ true
]

{ #category : #hooks }
RSDraggable >> onElement: e [
	e when: TSMouseDragging do: [ :evt |
		| d |
		d := e parent camera distanceFromPixelToSpace: evt step. 
		e translateBy: d.
		e signalUpdate.
		 ].
]
