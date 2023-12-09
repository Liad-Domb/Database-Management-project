QUERY_ANSWERS = {
    "Q3":
        """
SELECT family_devices.hid, family_devices.DevicesNum
FROM  family_devices;
        """
    ,
    "Q4":
        """
select st.hID, st.title, st.eTime as eventTime
from Show_time st
order by st.eTime,st.hID ASC
        """
}
