package org.study.hadoop.sales.one;

import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class SalesMapper
        extends Mapper<LongWritable, Text, Text, IntWritable> {

    @Override
    public void map(LongWritable key, Text value, Context context)
            throws IOException, InterruptedException {
        String line = value.toString();
        String[] array = line.split(",");
        String productId = array[1];
        Integer salesCount = Integer.parseInt(array[2]);
        if (productId.startsWith("A")) {
            String pid = productId.replace("-", "");
            context.write(new Text(pid),
                    new IntWritable(salesCount));
        }
    }
}