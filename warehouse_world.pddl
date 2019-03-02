(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
        :parameters (?s - shipment ?o - order ?l - location)
        :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
        :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
        :parameters (?r - robot ?s - location ?d - location)
        :precondition (and (connected ?s ?d) (at ?r ?s) (no-robot ?d))
        :effect (and (at ?r ?d) (no-robot ?s) (not (no-robot ?d)))
   )
   
   (:action robotMoveWithPallette
        :parameters (?r - robot ?p - pallette ?s - location ?d - location)
        :precondition (and (connected ?s ?d) (at ?r ?s) (at ?p ?s) (no-robot ?d) (no-pallette ?d))
        :effect (and (at ?r ?d) (at ?p ?d) (no-robot ?s) (no-pallette ?s) (not (no-robot ?d)) (not (no-pallette ?d)))
   )
   
   (:action moveItemFromPalletteToShipment
        :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
        :precondition (and (ships ?s ?o) (orders ?o ?si) (started ?s) (not (complete ?s)) (packing-location ?l) (packing-at ?s ?l) (at ?p ?l) (contains ?p ?si))
        :effect (and (not (contains ?p ?si)) (includes ?s ?si))
   )
   
   (:action completeShipment
        :parameters (?s - shipment ?o - order ?l - location)
        :precondition (and (started ?s) (not (complete ?s)) (ships ?s ?o) (packing-location ?l) (packing-at ?s ?l))
        :effect (and (complete ?s) (not (packing-at ?s ?l)) (available ?l))
   )

)
