package model;

public class Offer {

	public String consumer;
	public double price;
	public int time2Delivery;
	public int bca;
	public double utility;

	public Offer(String consumer, double price, int time2Delivery, int bca) {
		this.consumer = consumer;
		this.price = price;
		this.time2Delivery = time2Delivery;
		this.bca = bca;
	}

	@Override
	public String toString() {
		return consumer.concat(" ($" + price + " - " + time2Delivery + "h. - " + bca + "pts.) - utility:" + utility);
	}

}
