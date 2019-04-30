(defn main
  "Main function"
  []
  (loop [line (read-line)]
    (if (nil? line)
      nil
      (do (let [tokens (map #(Long/parseLong %) (.split line " +"))]
            (println tokens)
            <+CURSOR+>)
          (recur (read-line))))))

(main)
