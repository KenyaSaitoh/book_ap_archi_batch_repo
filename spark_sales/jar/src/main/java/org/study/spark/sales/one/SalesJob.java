package org.study.spark.sales.one;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;

import scala.Tuple2;

public class SalesJob {
    private static String target = "A";

    @SuppressWarnings("resource")
    public static void main(String[] args) throws Exception {
        SparkConf conf = new SparkConf().setAppName("SalesOneJob").setMaster("local");
        JavaSparkContext sc = new JavaSparkContext(conf);
        JavaRDD<String> salesFile = sc.textFile(
                "hdfs://cdh5-1:8020//user/root/input/sales_one/SALES_ONE.csv");
        JavaRDD<Sales> salesList = salesFile.map(s -> {
                String[] array = s.split(",");
                return new Sales(Integer.parseInt(array[0]), array[1],
                        Integer.parseInt(array[2]));
            });
        JavaPairRDD<String, Integer> countPair = salesList
                .filter(s -> s.getProductId().startsWith(target))
                .map(s -> {
                    String productId = s.getProductId()
                            .replaceAll("([A-Z])-(.*)", "$1$2");
                    return new Sales(s.getSalesId(), productId,
                            s.getSalesCount());
                    })
                .mapToPair(s -> new Tuple2<String, Integer>(
                        s.getProductId(), s.getSalesCount()))
                .reduceByKey((x, y) -> x + y);
        for (String key : countPair.keys().collect()) {
            System.out.println(key + " ---> " + countPair.lookup(key));
        }
        sc.close();
    }
}