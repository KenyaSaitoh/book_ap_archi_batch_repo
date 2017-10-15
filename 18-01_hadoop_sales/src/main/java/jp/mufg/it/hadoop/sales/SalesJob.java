package jp.mufg.it.hadoop.sales;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;

public class SalesJob {
    public static void main(String[] args) throws Exception {
        // Configurationオブジェクトを生成する。
        Configuration conf = new Configuration();

        // ジョブを生成する。
        Job job = Job.getInstance(conf);

        // ジョブのクラスを設定する。
        job.setJarByClass(SalesJob.class);

        // ジョブの名前を設定する。
        job.setJobName("SalesOneJob");

        // Mapperクラスを設定する。
        job.setMapperClass(SalesMapper.class);

        // Recuderクラスを設定する。
        job.setReducerClass(SalesReducer.class);

        // マップ出力におけるキーの型を設定する。
        job.setOutputKeyClass(Text.class);

        // マップ出力における値の型を設定する。
        job.setOutputValueClass(IntWritable.class);

        // 出力フォーマットクラスを設定する。
        job.setOutputFormatClass(TextOutputFormat.class);

        // 入力元のディレクトリを設定する。
        FileInputFormat.setInputPaths(job, new Path(args[0]));

        // 出力先のディレクトリを設定する。
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        // ジョブを実行する。
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}