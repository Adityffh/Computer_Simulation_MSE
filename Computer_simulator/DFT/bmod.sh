#!/bin/bash
for (( i = 0; i <= 10; i++ ))
do
a1=`echo "7.4 + ($i * 0.05)" | bc -l`
cat > scf.in << EOF
&CONTROL
calculation = 'scf'
prefix = 'Al'
pseudo_dir = './'
/
&SYSTEM
ibrav=  2,
celldm(1) =$a1,
nat=  1,
ntyp= 1,
ecutwfc =30,
ecutrho=150,
occupations='smearing',
smearing='mp',
degauss=0.02,
/
&ELECTRONS
/
K_POINTS automatic
16 16 16 0 0 0
ATOMIC_SPECIES
V 50.94 V.pbe-spnl-kjpaw_psl.1.0.0.UPF
ATOMIC_POSITIONS crystal
V 0 0 0
EOF
/opt/QE/espresso_6.5/bin/pw.x < scf.in > scf.out
grep ! scf.out | awk '{print $5}' > ene
grep 'lattice parameter' scf.out | awk '{print $5}' > lp
paste lp ene >> bmod.dat
done
