package org.co2;

import java.util.Arrays;
import java.util.Iterator;
import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.util.GenericOptionsParser;

// Notre classe REDUCE.

public class CO2Reduce extends Reducer<Text, Text, Text, Text> {
	// La fonction REDUCE.
	// Les arguments:
	// - La cle key,
	// - Un Iterable de toutes les valeurs qui sont associees a la cle en question
	// - Le contexte Hadoop (un handle qui nous permet de renvoyer le resultat a
	// Hadoop).
	// On calcule la moyenne des malus/bonus, des couts et des rejets
	// On écrit le couple key value dans le contexte

	public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {

		String malus_bonus;
		String rejet;
		String cout;

		int sommeBonus_Malus = 0;
		int sommeRejet = 0;
		int sommeCout = 0;

		int count = 0;
		int moy_Malus_Bonus = 0;
		int moy_Rejet = 0;
		int moy_Cout = 0;

		Iterator<Text> i = values.iterator();
		while (i.hasNext()) {
			String value = i.next().toString();

			String[] splitted_value = value.split("\\|");
			malus_bonus = splitted_value[0];
			rejet = splitted_value[1];
			cout = splitted_value[2];

			sommeBonus_Malus += Integer.parseInt(malus_bonus);
			sommeRejet += Integer.parseInt(rejet);
			sommeCout += Integer.parseInt(cout);

			count++;
		}
		moy_Malus_Bonus = sommeBonus_Malus / count;
		moy_Rejet = sommeRejet / count;
		moy_Cout = sommeCout / count;

		context.write(key, new Text(moy_Malus_Bonus + "\t" + moy_Rejet + "\t" + moy_Cout));
	}
}