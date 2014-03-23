all: forward_selection_arff.jar

forward_selection_arff.jar: ForwardSelectionARFF.java Manifest.txt weka.jar
	javac -cp weka.jar -d bin ForwardSelectionARFF.java
	jar cfm forward_selection_arff.jar Manifest.txt -C bin .
	rm -rf bin/*

.PHONY: clean

clean:
	rm -f forward_selection_arff.jar
	rm -rf bin/*
