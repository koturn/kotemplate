(defn main
  "Main function"
  []
  (let [line (ref (read-line))]
    (while (not (nil? (deref line)))
      (let [tokens (map #(Long/parseLong %) (.split (deref line) " +"))]
        (println tokens)
        <+CURSOR+>
        (dosync (ref-set line (read-line)))))))

(main)
