"
I set the drag event for view, I use a basic bars to do that
"
Class {
	#name : #RSDraggableView,
	#superclass : #RSAbstractControlView,
	#instVars : [
		'mouseEvent',
		'isMoving',
		'lastStep'
	],
	#category : #'Roassal3-Interaction-Controls'
}

{ #category : #accessing }
RSDraggableView class >> left [
	^ self new left
]

{ #category : #accessing }
RSDraggableView class >> middle [
	^ self new middle
]

{ #category : #accessing }
RSDraggableView class >> right [
	^ self new right
]

{ #category : #mouse }
RSDraggableView >> all [
	"Any mouse button can be used to drag and drop the view"
	mouseEvent := TSMouseDragStart.
]

{ #category : #computing }
RSDraggableView >> checkCameraView: aView [
	| camera p correct |
	camera := aView camera.
	p := camera position.
	correct := self correctCameraPosition: aView.
	correct = p ifTrue: [ ^ self ].
	
	self removeRectanglesFor: aView.
	
	aView newAnimation
		easing: TSEasing cubicIn;
		duration: 200 milliSeconds;
		from: p;
		to: correct;
		on: camera set: #translateTo:.
]

{ #category : #initialize }
RSDraggableView >> initialize [
	super initialize.
	self all.
	isMoving := false.
]

{ #category : #mouse }
RSDraggableView >> left [
	mouseEvent := TSMouseLeftDragStart
]

{ #category : #mouse }
RSDraggableView >> middle [
	mouseEvent := TSMouseMiddleDragStart
]

{ #category : #events }
RSDraggableView >> mouseEnd: evt [
	| threshold aView camera delta p correct |
	isMoving := false.
	lastStep ifNil: [ ^ self ].
	aView := evt view.
	camera := evt camera.
	threshold := 4.
	(lastStep dist: 0@0) < threshold
		ifTrue: [ ^ self checkCameraView: aView ].
		
	delta := lastStep * 2.5.
	camera translateBy: delta.
	correct := self correctCameraPosition: evt.
	camera translateBy: delta negated.
			
	p := (correct - camera position) abs max: 1@1.
	p := p x sqrt @ p y sqrt.
	
	aView newAnimation 
		easing: TSEasing cubicOut;
		duration: 200 milliSeconds;
		from: camera position; to: camera position + (delta / p);
		on: camera set: #translateTo:;
		when: TSAnimationEndEvent do: [ self checkCameraView: aView ].
		

]

{ #category : #mouse }
RSDraggableView >> mouseEvent [
	^ mouseEvent
]

{ #category : #events }
RSDraggableView >> mouseMove: evt [
	| camera p correct |
	isMoving ifFalse: [ ^ self ].
	camera := evt camera.
	lastStep := evt step negated / camera scale.
	correct  := self correctCameraPosition: evt.
	p := (correct - camera position) abs max: 1@1.
	p := p x sqrt @ p y sqrt.
	camera translateBy: lastStep/ p.
	evt signalUpdate.
]

{ #category : #events }
RSDraggableView >> mouseStart: evt [
	isMoving := true.
	lastStep := nil.
]

{ #category : #hooks }
RSDraggableView >> onElement: aView [
	aView 
		when: self mouseEvent do: [ :evt | self mouseStart: evt ];
		when: TSMouseDragging do: [ :evt | self mouseMove: evt ];
		when: TSMouseDragEnd do: [ :evt | self mouseEnd: evt ].
]

{ #category : #rendering }
RSDraggableView >> renderOn: lb [
	lb text: 'Mouse click' description: 'To move the view''s camera'
]

{ #category : #mouse }
RSDraggableView >> right [
	mouseEvent := TSMouseRightDragStart.
]
