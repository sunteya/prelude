class Cdr
  include Mongoid::Document
  include Mongoid::Search

  belongs_to :user

  field :sport, type: String
  field :dport, type: String
  field :ip_saddr, type: String
  field :ip_daddr, type: String
  field :size, type: Integer
  field :last_pcap_time, type: String
  field :created_at, type: Time
  
  def self.add_cdr
    file_path = "/home/msyesyan/Documents/log/"
    #to delete the file where created_at is a week ago
    Cdr.foreach_files(file_path) do |file|
      if Cdr.contruct_the_time(file).to_time < Time.now.ago(1.week)
        #TODO maybe the user: www-data can't delete the file
        File.delete(file_path + file)
      end
    end
    
    #to add the cdr
    cdr = Cdr.last
    last_pcap_time = Cdr.contruct_the_time(cdr.last_pcap_time) if cdr
    Cdr.foreach_files(file_path) do |file|
      next if last_pcap_time && last_pcap_time.to_time >= Cdr.contruct_the_time(file).to_time
      Cdr.insert_cdr(file_path, file)
    end
  end
  
  def self.insert_cdr(file_path, file_name)
    server_ip = "192.168.37.130"
    
    PacketFu::PcapFile.read_packets(file_path + file_name) do |packet|
      current_proto = packet.protocol.last.downcase;
      #exclude ipv6 and arp
      next if current_proto == "arp" || current_proto == "ipv6" || !packet.respond_to?(current_proto + "_src")

      user_port = (packet.ip_saddr == server_ip) ? packet.send(current_proto + "_src") : packet.send(current_proto + "_dst")
      # user = User.where(:port => user_port).first
      next if user.nil?
      puts "useremail:#{user.email}"
     
      Cdr.create!(:sport        => packet.send(current_proto + "_src"),
                  :dport        => packet.send(current_proto + "_dst"),
                  :ip_saddr       => packet.ip_saddr,
                  :ip_daddr       => packet.ip_daddr,
                  :size           => packet.size.to_i,
                  :user           => user,
                  :last_pcap_time => file_name,
                  :created_at     => Time.now
        )
    end
  
  end
  
  def self.foreach_files(file_path, &block)
    count = 0
    file_names = [] unless block
    Dir.foreach(file_path) do |file|
      next if file == "." || file == ".."
      if block
        count += 1
        yield(file)
      else
        file_names << file
      end
    end
    block ? count : file_names
  end
  
  def self.contruct_the_time(file)
    filename_arr = file.split(".")[0].split("-")
    filename = filename_arr[0..2].join("-") + " " + filename_arr[3..5].join(":")
  end
end
