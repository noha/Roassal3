"
I am the base for attach points
"
Class {
	#name : #RSAttachPoint,
	#superclass : #RSObject,
	#instVars : [
		'inverted'
	],
	#category : #'Roassal3-AttachPoint'
}

{ #category : #'instance creation' }
RSAttachPoint class >> centered [
	^ RSCenteredAttachPoint new
]

{ #category : #'public - hooks' }
RSAttachPoint >> basicEndingPointOf: anEdge [
	^ self subclassResponsibility 
]

{ #category : #'public - hooks' }
RSAttachPoint >> basicStartingPointOf: anEdge [
	^ self subclassResponsibility 
]

{ #category : #'public - hooks' }
RSAttachPoint >> endingPointOf: anEdge [
	(anEdge from = anEdge to) 
		ifTrue: [ ^ self position: anEdge from ].
    ^ inverted
        ifTrue: [ self basicStartingPointOf: anEdge ]
        ifFalse: [ self basicEndingPointOf: anEdge ]
]

{ #category : #'public - hooks' }
RSAttachPoint >> initialize [
	super initialize.
	inverted := false.
]

{ #category : #private }
RSAttachPoint >> position: anObject [
	anObject isPoint ifTrue: [ ^ anObject ].
	^ self positionFor: anObject point: anObject position.
]

{ #category : #private }
RSAttachPoint >> positionFor: anElement point: aPoint [
	| parent |
	(parent := anElement parent )ifNil: [ ^ aPoint ].
	^ parent transform: aPoint
	
]

{ #category : #'public - hooks' }
RSAttachPoint >> startingPointOf: anEdge [
	(anEdge from = anEdge to) 
		ifTrue: [ ^ self position: anEdge from ].
    ^ inverted
        ifTrue: [ self basicEndingPointOf: anEdge ]
        ifFalse: [ self basicStartingPointOf: anEdge ]

]
