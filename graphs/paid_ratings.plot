set terminal pdf dashed size 12,3
set output "paid_ratings.pdf"

set title "Free/Paid Rating (free apps)"
set key invert reverse Left outside

set ylabel "Average Ratings with StdDev" offset +2, 0
set xlabel "Number of Downloads" offset 0,+0.2
set grid y
 set yrange [0:5.5]

set ytics 0.5

set style data histograms
set style histogram errorbars lw 3 gap 1
set bars front
set style fill solid border -1
set boxwidth 1

plot 'paid_ratings.dat' using ($2):($2-$3):($2+$3):xtic(1) lt 1 lc 1 fs solid 0.5 t "Free", \
                     '' using ($4):($4-$5):($4+$5):xtic(1) lt 1 lc 2 fs solid 0.5   t "Paid"
