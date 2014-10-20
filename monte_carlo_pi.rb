def random_point
  rand = Random.new
  [rand.rand(1.0), rand.rand(1.0)]
end

def distance x1, y1, x2, y2
  Math.sqrt((x2-x1)**2+(y2-y1)**2)
end

def run_sim
  in_circle = 0
  iter = 500000
  for i in 0..iter do
    x, y = random_point
    dist = distance x, y, 1, 1
    if dist < 1
      in_circle += 1
    end
  end

  ratio = in_circle.to_f / iter.to_f
  ratio * 4.0
end

printf("%0.9f\n", run_sim)
# puts distance(0,0,1,1)
