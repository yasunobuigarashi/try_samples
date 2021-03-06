import Control.Arrow

type KnightPos = (Int, Int)

moveKnight :: KnightPos -> [KnightPos]
moveKnight (c, r) = filter onBoard
	[
		(c + 2, r - 1), (c + 2, r + 1),
		(c - 2, r - 1), (c - 2, r + 1),
		(c + 1, r - 2), (c + 1, r + 2),
		(c - 1, r - 2), (c - 1, r + 2)
	]
	where onBoard (c', r') = c' `elem` [1..8] && r' `elem` [1..8]

in3 :: Kleisli [] KnightPos KnightPos
in3 = Kleisli moveKnight >>> Kleisli moveKnight >>> Kleisli moveKnight

canReachIn3 :: Arrow a => KnightPos -> a KnightPos Bool
canReachIn3 end = arr (runKleisli in3) >>> arr (elem end)

main = do
	print $ runKleisli in3 $ (6, 2)

	print $ canReachIn3 (6, 1) $ (6, 2)
	print $ canReachIn3 (7, 3) $ (6, 2)
