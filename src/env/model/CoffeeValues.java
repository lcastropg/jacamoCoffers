package model;

public enum CoffeeValues {
	
	
	MIN_COFFEEPRICE(5),
	MAX_COFFEEPRICE(40),
	
	MIN_TIME(1),
	MAX_TIME(48),
	
	MIN_BCA(80),
	MAX_BCA(100),
	
	THRESHOLD(7);
	
	private final int value;
	
		
	CoffeeValues(int value){
		this.value = value;
	}
	
	public int getValue() {
		return value;
	}
	

}
