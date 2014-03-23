package edu.umich.crazy_features;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import weka.classifiers.Evaluation;
import weka.classifiers.trees.J48;
import weka.core.Instances;
import weka.core.converters.ConverterUtils.DataSource;
import weka.filters.Filter;
import weka.filters.unsupervised.attribute.Remove;

public class ForwardSelectionARFF {

    public static void main(String[] args) {
        try {
            InputStream inputStream = new FileInputStream(args[0]);
            DataSource source = new DataSource(inputStream);
            
            Instances data = source.getDataSet();
            if (data.classIndex() == -1)
                data.setClassIndex(data.numAttributes() - 1);
            inputStream.close();
            
            Scanner in = new Scanner(System.in);
            
            int num_features = data.numAttributes() - 1;
            
            // TODO: Print out the features
            System.out.println(data.toString());
            
            while (true) {
                // Input the candidate features bitmask
                System.out.print("\nEnter a candidate features bitmask (-1 to quit): ");
                int features_bitmask = in.nextInt(2);
                if (features_bitmask == -1)
                    break;
                
                // Choose the candidate features
                List<Boolean> candidate_features = new ArrayList<Boolean>();
                for (int i = 0, pos = 1 << num_features; i < num_features; i++) {
                    pos >>= 1;
                    if ((features_bitmask & pos) != 0)
                        candidate_features.add(true);
                    else
                        candidate_features.add(false);
                }
                
                // Do the forward selection
                List<Integer> selected_features = new ArrayList<Integer>();
                double pctCorrect = 0;
                while (true) {
                    int next_feature = -1;
                    double next_pctCorrect = pctCorrect;
                    
                    for (int i = 0; i < num_features; i++) {
                        if (!candidate_features.get(i) || selected_features.contains(i))
                            continue;
                        
                        // get temporary data of selected features
                        selected_features.add(i);
                        Instances selected_data = getInstancesOfSelectedFeatures(data, selected_features);
                        
                        // evaluate the selected_data and update the next_feature and next_pctCorrect if nessary
                        double pctCorrect_of_selected_data = wekaEvaluate(selected_data);
//                        System.out.println("Feature " + i + ": " + pctCorrect_of_selected_data);
                        if (pctCorrect_of_selected_data > next_pctCorrect) {
                            next_pctCorrect = pctCorrect_of_selected_data;
                            next_feature = i;
                        }
                        
                        selected_features.remove(selected_features.size() - 1);
                    } // for (int i = 0; i < num_features; i++)
                    
                    if (next_feature == -1) {
                        break;
                    } else {
                        selected_features.add(next_feature);
                        pctCorrect = next_pctCorrect;
                        
                        System.out.print("Selected features:");
                        for (Integer i : selected_features) {
                            System.out.print(i + 1 + " ");
                        }
                        System.out.println("\n  pctCorrect: " + Double.toString(pctCorrect));
                    }
                } // while (true) for the forward selection loop
            } // while (true) for the main loop
            
            System.out.println("Quit");
            
            in.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    static private Instances getInstancesOfSelectedFeatures(Instances data, List<Integer> selected_features) throws Exception {
        List<Integer> features = new ArrayList<>(selected_features);
        features.add(data.numAttributes() - 1);
        Remove remove = new Remove();
        remove.setInvertSelection(true);
        remove.setAttributeIndicesArray(toIntArray(features));
        remove.setInputFormat(data);
        Instances selected_data = Filter.useFilter(data, remove);
        if (selected_data.numClasses() == -1)
            selected_data.setClassIndex(selected_data.numAttributes() - 1);
        
        return selected_data;
    }

    static private int[] toIntArray(List<Integer> list) {
        int[] arr = new int[list.size()];
        
        for (int i = 0; i < list.size(); i++)
            arr[i] = list.get(i);
        
        return arr;
    }
    
    static private double wekaEvaluate(Instances data) throws Exception {       
        J48 tree = new J48();
        tree.setUnpruned(true);
        tree.buildClassifier(data);
        
        Evaluation eval = new Evaluation(data);
        // TODO: Don't understand the third argument of evaluateModel
        eval.evaluateModel(tree, data, new Object[1]);
        
        return eval.pctCorrect();
    }
}
