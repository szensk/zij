; zij.clj
; learning clojure?

(def ^:const Z 0) ; zero 
(def ^:const I 1) ; increment
(def ^:const J 2) ; jump if not equal

(defn simulate
  [code, memory, location]
  (if (>= location (count code))
    memory
    (let [opcode (first (get code location)) at (second (get code location))]
      (condp = opcode 
        Z (simulate code (assoc memory at 0) (inc location))
        I (simulate code (assoc memory at (+ (get memory at) 1)) (inc location)) 
        J (let [at (subvec (get code location) 1 3)]
            (if (= (get memory (first at)) (get memory (second at)))
              (simulate code, memory, (inc location)) ; branch not taken
              (simulate code, memory, (get (get code location) 3)) ; branch taken
            )
          )
      )
    )
  )
)

(def program ; adds value of m0 and m1, storing result in m2, clobbers m3
  [[Z 2] 
   [Z 3]
   [I 2] 
   [J 2 0 2] 
   [I 2] 
   [I 3]
   [J 3 1 4] 
   [Z 3]]
)

(def memory 
  [3 4 0 0]
)

(println (str "Program code size: " (count program)))
(time (simulate program memory 0))
