#for fill in 3131 3133 3134 3135 3138 3178 3182 3185 3188 3191 3192 3194 3200 3201 3203 3204 3207 3208 3209 3210 3212 3214 3223 3226 3229 3231 3232 3236 3238 3240 3242 3244 3249 3250 3252 3253 3259 3261 3264 3265 3266 3269 3272 3273 3279 3285 3286 3287
for fill in 3288 3292
do
if [ -f fill.$fill.txt ] 
then
root -l << EOF
.x loadlibs.C
AliMUONTrackerHV h("fill.$fill.txt","local:///Users/laurent/Alice/OCDBcopy");
h.ReportTrips();  > trips.$fill.txt
EOF
fi
done 