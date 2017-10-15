package jp.mufg.it.spark.sales;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;

import scala.Tuple2;

public class SalesJobOnYarn {
    private static String target = "A";

    @SuppressWarnings("resource")
    public static void main(String[] args) throws Exception {
        SparkConf conf = new SparkConf().setAppName("SalesOneJob");
        JavaSparkContext sc = new JavaSparkContext(conf);
        JavaRDD<String> salesFile = sc.textFile(args[0]);
        JavaRDD<Sales> salesList = salesFile.map(s -> {
            String[] array = s.split(",");
            return new Sales(Integer.parseInt(array[0]), array[1],
                    Integer.parseInt(array[2]));
        });
        JavaPairRDD<String, Integer> countPair = salesList
                .filter(s -> s.getProductId().startsWith(target))
                .map(s -> {
                    String pid = s.getProductId().replace("-", "");
                    return new Sales(s.getSalesId(), pid,
                            s.getSalesCount());
                    })
                .mapToPair(s -> new Tuple2<String, Integer>(
                        s.getProductId(), s.getSalesCount()))
                .reduceByKey((x, y) -> x + y);
        countPair.saveAsTextFile(args[1]);
        sc.close();
    }
}